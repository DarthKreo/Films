//
//  UIAlertController.swift
//  Films
//
//  Created by Владимир Кваша on 07.10.2020.
//

import UIKit

extension UIViewController {
    
    func presentAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        }
    }

