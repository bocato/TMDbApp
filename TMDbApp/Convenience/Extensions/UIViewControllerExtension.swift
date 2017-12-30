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
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(xButtonDidReceiveTouchUpInside(_:)))
    }
  }
  
  @objc private func xButtonDidReceiveTouchUpInside(_ sender: UIBarButtonItem) {
    navigationController?.dismiss(animated: true, completion: nil)
  }
  
}
