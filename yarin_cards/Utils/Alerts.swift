//
//  Alerts.swift
//  yarin_cards
//
//  Created by Udi Levy on 17/07/2024.
//

import UIKit

class Alerts {
    static func showAlert(on viewController: UIViewController, withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func promptForName(on viewController: UIViewController, completion: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "Enter Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Name"
        }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            let name = alertController.textFields?.first?.text
            completion(name)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(nil)
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
