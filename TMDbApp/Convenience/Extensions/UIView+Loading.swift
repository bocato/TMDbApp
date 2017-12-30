//
//  UIView+Loading.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

fileprivate let loadingViewIdentifier = 101010

extension UIView {
    
    func startLoading(_ activityIndicatorStyle: UIActivityIndicatorViewStyle = .gray, tintColor: UIColor = UIColor.darkGray, backgroundColor: UIColor = UIColor.clear) {
        
        let loadingView = UIView()
        loadingView.frame = self.bounds
        loadingView.tag = loadingViewIdentifier
        loadingView.backgroundColor = backgroundColor

        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: activityIndicatorStyle)
        activityIndicator.frame = self.bounds
        activityIndicator.tintColor = tintColor
        activityIndicator.configureShadow()
        activityIndicator.startAnimating()

        loadingView.addSubview(activityIndicator)
        
        DispatchQueue.main.async {
            self.addSubview(loadingView)
            self.isUserInteractionEnabled = false
        }
    }

    func stopLoading() {
        let holderView = self.viewWithTag(loadingViewIdentifier)
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = true
            holderView?.removeFromSuperview()
        }
    }
    
}
