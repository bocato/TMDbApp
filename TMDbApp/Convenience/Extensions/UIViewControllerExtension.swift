//
//  UIViewControllerExtension.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

extension UIViewController {
  
  // MARK: X Button Configuration
  func configureXButtonOnRightBarButtonItem() {
    if let _ = navigationController {
      navigationItem.hidesBackButton = true
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(didTapXButton(_:)))
    }
  }
  
  @objc private func didTapXButton(_ sender: UIBarButtonItem) {
    navigationController?.dismiss(animated: true, completion: nil)
  }
  
  // MARK: Alerts
//  func showAlert(for error: Error) {
//    guard let serviceError = error as? ServiceError, let alertText = serviceError.message else { return }
//    let bottomAlertController = BottomAlertController.instantiateNew(withText: alertText, buttonTitle: "Ok", actionClosure: nil)
//    self.present(bottomAlertController, animated: true, completion: nil)
//  }
  
}
