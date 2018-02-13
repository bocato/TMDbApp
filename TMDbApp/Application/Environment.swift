//
//  Environment.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

class Environment {
    
    // MARK: Enums
    enum EnvironmentType: String {
        case dev = "dev"
    }
    
    // MARK: - Singleton
    static let shared = Environment()
    
    // MARK: - Properties
    var apiKey: String!
    var baseURL: String!
    var baseURLForImages: String!
    var runtimeEnvironment: EnvironmentType?
    
    // MARK: - Computed Properties
    var currentRuntimeEnvironment: EnvironmentType? {
        if let runtimeEnvironment = runtimeEnvironment {
            return runtimeEnvironment
        } else if let environment = Bundle.main.object(forInfoDictionaryKey: "ENVIRONMENT") as? String {
            switch environment {
            case "dev":
                return .dev
            default:
                return .dev
            }
        }
        return .dev
    }
    
    // MARK: - Lifecycle
    init() {
        setup()
    }
    
    // MARK: - Configuration
    func setup() {
        guard let runtimeEnvironment = currentRuntimeEnvironment else { return }
        switch runtimeEnvironment {
        case .dev:
            self.baseURL = "https://api.themoviedb.org/3"
            self.apiKey = "a8cb83333f21cac3cdf6e22c010fbd74"
            self.baseURLForImages = "https://image.tmdb.org/t/p/w500"
            break
        }
    }
    
}
