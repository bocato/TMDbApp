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
    
    
    func setAndLayoutTableHeaderView(header: UIView) { //set the tableHeaderView so that the required height can be determined, update the header's frame and set it again
        self.tableHeaderView = header
        header.setNeedsLayout()
        header.layoutIfNeeded()
        header.frame.size = header.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        self.tableHeaderView = header
    }
    
}
