//
//  ServiceResponse.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

struct ServiceResponse {
    
    // MARK: - Properties
    var data: Data?
    
    var rawResponse: String?
    var response: HTTPURLResponse?
    var request: URLRequest?
    
    var serviceError: ServiceError?
    
}
