//
//  UIView+Extension.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

public extension UIView {
    
    func configureShadow(withShadowOffset shadowOffset: CGSize = CGSize(width: 0, height: 5.0),
                         shadowRadius: CGFloat = 8.0,
                         shadowColor: CGColor = UIColor.darkGray.cgColor,
                         shadowOpacity: Float = 0.6,
                         shadowPath: CGPath? =  nil) {
        layer.shadowOffset = shadowOffset
        layer.shadowColor = shadowColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath
    }
    
    func configureRoundedBorders(with borderWidth: CGFloat = 0.1,
                             cornerRadius: CGFloat = 10,
                             borderColor: CGColor = UIColor.clear.cgColor) {
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
