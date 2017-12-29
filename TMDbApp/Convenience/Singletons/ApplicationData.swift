//
//  ApplicationData.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

class ApplicationData {
    
    // MARK: - Singleton
    static let shared = ApplicationData()
    
    // MARK: Properties
    var movieGenres: [Genre]?
    
}
