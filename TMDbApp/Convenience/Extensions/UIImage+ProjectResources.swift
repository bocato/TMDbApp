//
//  UIImage+ProjectResources.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

enum Images: String {
    case film = "ic_film"
    case magnifierTool = "ic_magnifier_tool"
    case squaredSadFace = "ic_squared_sad_face"
    case sadManWithHat = "ic_sad_man_with_hat"
    case star = "ic_star"
    case loadingBackdrop = "ic_loading_backdrop"
    case loadingMoviePoster = "ic_loading_movie"
    case noPoster = "ic_no_poster"
    case noBackdrop = "ic_no_backdrop"
}

extension UIImage {
    
    static func fromResource(named name: Images) -> UIImage? {
        return UIImage(named: name.rawValue)
    }
    
}
