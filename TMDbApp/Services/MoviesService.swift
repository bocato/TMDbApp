//
//  MoviesService.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 29/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

class MoviesService {
    
    func getSimilarMovies(for movieId: Int!, page: Int = 1, success: @escaping ((_ response: SearchResponse?, _ serviceResponse: ServiceResponse?) -> Void), onFailure failure: ((ServiceResponse?) -> Void)? = nil, onCompletion completion: (() -> Void)? = nil){
        
        let queryParameters = URLHelper.escapedParameters(["api_key": Environment.shared.apiKey, "page":  page])
        let url = URL(string: Environment.shared.baseURL + "/movie/\(movieId)/similar" + queryParameters)!
        
        Service.shared.request(httpMethod: .get, url: url).response(succeed: { (response: SearchResponse?, _ serviceResponse: ServiceResponse?) in
            success(searchResponse, serviceResponse)
        }, failed: { errorResponse in
            failure?(errorResponse)
        }, completed: {
            completion?()
        })
    }
    
}
