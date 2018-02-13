//
//  GenresService.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

class GenresService {
    
    func getGenres(onSuccess success: @escaping ((_ genres: [Genre]?, _ serviceResponse: ServiceResponse?) -> Void), onFailure failure: ((ServiceResponse?) -> Void)? = nil, onCompletion completion: (() -> Void)? = nil){
        
        let queryParameters = URLHelper.escapedParameters(["api_key": Environment.shared.apiKey])
        let url = URL(string: Environment.shared.baseURL + "/genre/movie/list" + queryParameters)!
        
        Service.shared.request(httpMethod: .get, url: url).response(succeed: { (genresResponse: GenresResponse?, serviceResponse: ServiceResponse?) in
            success(genresResponse?.genres, serviceResponse)
        }, failed: { errorResponse in
            failure?(errorResponse)
        }, completed: {
            completion?()
        })
        
    }
    
}

