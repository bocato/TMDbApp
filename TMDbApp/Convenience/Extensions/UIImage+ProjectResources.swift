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
    case moviePlaceholder = "ic_movie_placeholder"
    case magnifierTool = "ic_magnifier_tool"
}

extension UIImage {
    
    static func fromResource(named name: Images) -> UIImage? {
        return UIImage(named: name.rawValue)
    }
    
}
