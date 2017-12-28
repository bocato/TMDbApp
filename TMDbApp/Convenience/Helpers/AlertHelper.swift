//
//  AlertHelper.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

class AlertHelper: NSObject {
    
    static func showAlert(in controller: UIViewController, withTitle title: String?, message: String?, action: UIAlertAction? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action ?? defaultAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
    static func showAlert(in controller: UIViewController, withTitle title: String?, message: String?, yesAction: UIAlertAction!, noAction: UIAlertAction? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(noAction ?? UIAlertAction(title: "No", style: .default, handler: nil))
        alertController.addAction(yesAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
}
