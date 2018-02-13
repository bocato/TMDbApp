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
        stopLoading()
    }
    
    func setImage(with urlString: String?,
                  placeholderImage: UIImage? = nil, imageForError: UIImage? = nil, downloadedImageContentMode: UIViewContentMode? = .scaleAspectFit) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            image = placeholderImage
            return
        }
        self.contentMode = .scaleAspectFit
        startLoading()
        kf.setImage(with: url, placeholder: placeholderImage, options: [.transition(ImageTransition.fade(1))], progressBlock: nil) { (image, error, _, _) in
            DispatchQueue.main.async {
                if let _ = error {
                    guard let imageForError = imageForError else {
                        self.image = placeholderImage
                        return
                    }
                    self.image = imageForError
                } else {
                    self.image = image
                    if let downloadedImageContentMode = downloadedImageContentMode {
                        self.contentMode = downloadedImageContentMode
                    }
                }
                self.stopLoading()
            }
        }
    }
    
}
