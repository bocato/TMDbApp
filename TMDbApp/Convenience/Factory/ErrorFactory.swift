//
//  ErrorFactory.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 13/02/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

class ErrorFactory {
    
    static func buildServiceError(with code: ErrorCode!) -> ServiceError! {
        switch code {
        case .unknown:
            return ServiceError(statusMessage: ErrorMessage.unknown.rawValue, statusCode: ErrorCode.unknown.rawValue)
        case .unexpected:
            return ServiceError(statusMessage: ErrorMessage.unexpected.rawValue, statusCode: ErrorCode.unexpected.rawValue)
        default:
            return ServiceError(statusMessage: ErrorMessage.unknown.rawValue, statusCode: ErrorCode.unknown.rawValue)
        }
    }
    
}
