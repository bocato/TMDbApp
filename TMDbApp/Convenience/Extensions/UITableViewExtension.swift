//
//  UITableViewExtension.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

extension UITableView {
    
    var scrollDidReachBottom: Bool {
        return self.contentOffset.y >= (self.contentSize.height - self.frame.size.height)
    }
    
}
