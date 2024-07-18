//
//  ViewController.swift
//  yarin_cards
//
//  Created by Udi Levy on 17/07/2024.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnInsertName: UIButton!
    
    @IBOutlet weak var westPlayerName: UILabel!
    @IBOutlet weak var westPlayerScore: UILabel!
    @IBOutlet weak var imgWest: UIImageView!
    @IBOutlet weak var eastPlayerName: UILabel!
    @IBOutlet weak var eastPlayerScore: UILabel!
    @IBOutlet weak var imgEast: UIImageView!
    
    @IBOutlet weak var eastStack: UIStackView!
    @IBOutlet weak var westStack: UIStackView!
    @IBOutlet weak var btnStart: UIButton!
    
    let locationManager = CLLocationManager()
    var userLongitude: Double?
    
    var imageNames: [String]?
    
    @IBOutlet weak var viewGame: UIView!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblRound: UILabel!
    
    var currentRound = 1
    var timer: Timer?
    var roundTime = 3
    var hideTime = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initScreen();
        imageNames = Utils.getFileNames()
    }
    
    func getLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()  // Request permission for when the app is in use
        
    }
    
    func initScreen(){
        
        if let savedName = UserDefaultsUtils.getUserName() {
            updateUIWithName(savedName)
            getLocation();
        }
        
        
        viewGame.isHidden = true;
        eastStack.isHidden=true;
        westStack.isHidden=true;
    }
    
    // Handle the permission status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("Location permission not determined")
            //              Alerts.showAlert(on: self, withTitle: "Location Permission not determined", message: "Please enable location services in settings.")
        case .restricted, .denied:
            print("Location permission denied/restricted")
            Alerts.showAlert(on: self, withTitle: "Location Permission Denied", message: "Please enable location services in settings.")
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location permission granted")
            locationManager.startUpdatingLocation()
        @unknown default:
            fatalError()
        }
    }
    
    // Handle location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print("User's location: (\(latitude), \(longitude))")
            userLongitude=longitude;
            // Stop updating location to save battery
            
            locationManager.stopUpdatingLocation()
            if player1_left == nil {
                setPlayerPlaces()
            }
        }
    }
    
    @IBAction func btnInsertNameAction(_ sender: Any) {
        Alerts.promptForName(on: self) { [weak self] name in
            guard let self = self, let name = name, !Utils.trim(from: name).isEmpty else { return }
            UserDefaultsUtils.saveUserName(name)
            getLocation()
            self.updateUIWithName(name)
        }
    }
    @IBAction func btnStartAction(_ sender: Any) {
        btnStart.isHidden = true;
        viewGame.isHidden = false;
        startGame()
    }
    
    func updateUIWithName(_ name: String) {
        lblName.text = "Hi " + name
        lblName.isHidden = false
        btnInsertName.isHidden = true
    }
    var player1_left: Player?
    var player2_right: Player?
    
    func setPlayerPlaces(){
        let  savedName = UserDefaultsUtils.getUserName()
        
        if(userLongitude! < Constants.centerLongitude){
            
            player1_left = Player(name: savedName!)
            player2_right = Player(name: Constants.PC)
        }
        else{
            player1_left = Player(name:Constants.PC )
            player2_right = Player(name:savedName! )
        }
        btnStart.isHidden = false
        westPlayerName.text = player1_left?.name;
        eastPlayerName.text = player2_right?.name;
        
        updateScores();
        
    }
    
    func updateScores(){
        if let score1 = player1_left?.score {
            westPlayerScore.text = "\(String(describing:score1))";
        }
        if let score2 = player2_right?.score {
            eastPlayerScore.text = "\(String(describing: score2))";
        }
    }
    
    
    func startGame() {
        eastStack.isHidden=false;
        westStack.isHidden=false;
        currentRound = 0
        runRound()
    }
    
    func runRound() {

        currentRound += 1
        self.lblRound.text = "\(currentRound)"
        // Show random cards
        showRandomCards()
        
        // Start the timer for the round
        lblTimer.text = "3"
        var seconds = roundTime
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            seconds -= 1
            self.lblTimer.text = "\(seconds)"
            if seconds == 0 {
                timer.invalidate()
                self.hideCards()
            }
        }
    }
    
    func hideCards() {
        if(currentRound==Constants.maxRounds){
            initScreen();
            btnStart.isHidden=false;
            performSegue(withIdentifier: "game_over_screen", sender: self)
            player1_left?.score=0
            player2_right?.score=0
            
            
            return;
        }
        imgWest.isHidden = true
        imgEast.isHidden = true
        lblTimer.text = "5"
        var seconds = hideTime
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            seconds -= 1
            self.lblTimer.text = "\(seconds)"
            if seconds == 0 {
                timer.invalidate()
                self.runRound()
            }
        }
    }
    
    func showRandomCards() {
        guard let imageNames = imageNames else { return }
        imgWest.isHidden = false
        imgEast.isHidden = false
        
        let randomWestImage = imageNames.randomElement() ?? ""
        let randomEastImage = imageNames.randomElement() ?? ""
        
        var splitStringArray = randomWestImage.components(separatedBy: "_")
        let westValue = Int(splitStringArray.first!)
        
        //        if let intValue = Int(splitStringArray.first!) {
        //            player1_left?.score=intValue
        //       }
        
        splitStringArray = randomEastImage.components(separatedBy: "_")
        let eastValue = Int(splitStringArray.first!)
        //        if let intValue = Int(splitStringArray.first!) {
        //            player2_right?.score=intValue
        //       }
        if(eastValue != westValue){
            if(westValue! > eastValue!){
                player1_left?.score+=1;
            }
            else{
                player2_right?.score+=1;
            }
        }
        
        updateScores();
        
        imgWest.image = UIImage(named: randomWestImage)
        imgEast.image = UIImage(named: randomEastImage)
    }
    
    func endGame() {
        //        lblTimer.text = "Game Over"
        imgWest.isHidden = true
        imgEast.isHidden = true
        btnStart.isHidden = false
        viewGame.isHidden = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.game_over_screen {
            if let destinationVC = segue.destination as? GameOverViewController {
                let player = player1_left!.score>player2_right!.score ?player1_left:player2_right
                destinationVC.winnerPlayer = player;
            }
        }
    }
}

