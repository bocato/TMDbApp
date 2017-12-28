//
//  UIImageView+Kingfisher.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit
import Kingfisher


extension UIImageView {
    
    // MARK: - Kingfisher Methods
    func cancelDownloadTask() {
        kf.cancelDownloadTask()
    }
    
    func setImage(with urlString: String?,
                  placeholderImage: UIImage? = nil) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            image = placeholderImage
            return
        }
        startLoading()
        kf.setImage(with: url, placeholder: placeholderImage, options: [.transition(ImageTransition.fade(1))], progressBlock: nil) { (image, error, _, _) in
            DispatchQueue.main.async {
                if let _ = error {
                    self.image = placeholderImage
                } else {
                    self.image = image
                }
                self.stopLoading()
            }
        }
    }
    
}
