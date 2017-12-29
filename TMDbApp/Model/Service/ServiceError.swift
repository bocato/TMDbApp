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
    var statusMessage: String?
    var statusCode: Int?
    
    // MARK: CodingKeys
    enum CodingKeys : String, CodingKey {
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
    
}
