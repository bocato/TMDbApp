//
//  UITableViewCellExtension.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

extension UITableViewCell {
  
  static var identifier: String {
    return String(describing: self)
  }

}
