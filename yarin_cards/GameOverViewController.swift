//
//  GameOverViewController.swift
//  yarin_cards
//
//  Created by Udi Levy on 18/07/2024.
//

import UIKit

class GameOverViewController: UIViewController {
    @IBOutlet weak var lblWinner: UILabel!
    @IBOutlet weak var lblWinnerScore: UILabel!
    var winnerPlayer: Player?
    override func viewDidLoad() {
        super.viewDidLoad()
        lblWinner.text="Winner "+winnerPlayer!.name;
        if let score1 = winnerPlayer?.score {
            lblWinnerScore.text = "\(score1)"
            }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
