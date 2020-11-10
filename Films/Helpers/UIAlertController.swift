//
//  UIAlertController.swift
//  Films
//
//  Created by Владимир Кваша on 07.10.2020.
//

import UIKit

// MARK: - UIAlertController

extension UIViewController {
    
    // MARK: - Public methods
    
    func presentAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: Constants.AlertActionTitle,
                                                style: .default,
                                                handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Constants
    
    enum Constants {
        static let AlertActionTitle: String = "Ok"
    }
    
}
