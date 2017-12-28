//
//  SearchService.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

class SearchService {
    
    func findMovie(by name: String!, page: Int = 1, success: @escaping ((_ searchResponse: SearchResponse?, _ serviceResponse: ServiceResponse?) -> Void), onFailure failure: ((ServiceResponse?) -> Void)? = nil, onCompletion completion: (() -> Void)? = nil){
        
        let queryParameters = URLHelper.escapedParameters(["api_key": Environment.shared.apiKey, "query": name, "page":  page])
        let url = URL(string: Environment.shared.baseURL + "/search/movie" + queryParameters)!
        
        Service.shared.request(httpMethod: .get, url: url).response(succeed: { (searchResponse: SearchResponse?, _ serviceResponse: ServiceResponse?) in
            success(searchResponse, serviceResponse)
        }, failed: { errorResponse in
            failure?(errorResponse)
        }, completed: {
            completion?()
        })
    }
    
}
