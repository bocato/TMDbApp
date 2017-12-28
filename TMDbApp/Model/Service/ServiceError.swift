//
//  ServiceError.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

struct ServiceError: Codable, Error {
    
    // MARK: - Properties
    var statusCode: Int? // This is coming from the service
    var error: String? // This is coming from the service
    var message: String? // This is coming from the service
    
}
