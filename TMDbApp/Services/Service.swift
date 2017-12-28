//
//  Service.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

class Service {
    
    // MARK: - Properties
    static let shared = Service()
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case patch = "PATCH"
    }
    
    var defaultHeaders: [String: String] = [
        "content-type": "application/json"
    ]
    
    // MARK: - Misc
    func request(httpMethod: HTTPMethod, url: URL, payload: [String: Any]? = nil,
                 headers: [String:String]? = nil) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = defaultHeaders
        
        if let dict = payload {
            request.httpBody = JSON.serialize(dictionary: dict)
        }
        
        guard let headers = headers else {
            return request
        }
        
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return request
    }
}

// MARK: - URLRequestExtension
// handle HTTPURLResponse and dispatch the request
extension URLRequest {
    
    private func setUnknowErrorFor(serviceResponse: inout ServiceResponse) {
        serviceResponse.serviceError = ServiceError(statusCode: nil, error: "Unexpected.", message: "An unexpected error has occured. Check your internet connextion and try again.")
    }
    
    private func mapErrors(statusCode: Int, error: Error?, serviceResponse: inout ServiceResponse) {
        
        guard error == nil else {
            setUnknowErrorFor(serviceResponse: &serviceResponse)
            return
        }
        
        guard 400...499 ~= statusCode, let data = serviceResponse.data, let jsonString = String(data: data, encoding: .utf8),
            let serializedValue = try? JSONDecoder().decode(ServiceError.self, from: data) else {
                setUnknowErrorFor(serviceResponse: &serviceResponse)
                return
        }
        
        serviceResponse.rawResponse = jsonString
        
        if serializedValue.message == nil {
            setUnknowErrorFor(serviceResponse: &serviceResponse)
        } else {
            serviceResponse.serviceError = serializedValue
        }
    }

    // Dispatch URLRequest instance
    private func dispatch(onCompleted completion: @escaping (ServiceResponse) -> Void) {
        
        URLSession.shared.dataTask(with: self) { data, res, error in
            
            var serviceResponse = ServiceResponse()
            
            serviceResponse.response = res as? HTTPURLResponse
            serviceResponse.request = self
            serviceResponse.data = data
            
            if let data = data {
                serviceResponse.rawResponse = String(data: data, encoding: .utf8)
            }
            
            guard let statusCode = serviceResponse.response?.statusCode else {
                self.setUnknowErrorFor(serviceResponse: &serviceResponse)
                completion(serviceResponse)
                return
            }
            
            if !(200...299 ~= statusCode) {
                self.mapErrors(statusCode: statusCode, error: error, serviceResponse: &serviceResponse)
            }
            
            completion(serviceResponse)
            
            }.resume()
    }
    
    /// Use this method when there is no need to serialize service payload
    func response(succeed success: @escaping (ServiceResponse) -> Void,
                  failed failure: @escaping (ServiceResponse) -> Void,
                  completed completion: @escaping () -> Void) {
        
        dispatch { (serviceResponse) in
            
            if let _ = serviceResponse.serviceError {
                failure(serviceResponse)
            } else {
                success(serviceResponse)
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    /// Use this method to serialize object payload
    func response<SuccessObjectType: Codable>(succeed success: @escaping (SuccessObjectType?, ServiceResponse) -> Void,
                                              failed failure: @escaping (ServiceResponse) -> Void,
                                              completed completion: @escaping () -> Void) {
        
        
        dispatch { (serviceResponse) in
            
            if let _ = serviceResponse.serviceError {
                failure(serviceResponse)
            } else {
                if let data = serviceResponse.data {
                    do {
                        let serializedObject = try JSONDecoder().decode(SuccessObjectType.self, from: data)
                        success(serializedObject, serviceResponse)
                    } catch let parserError {
                        debugPrint("*** parserError ***")
                        debugPrint(parserError)
                        success(nil, serviceResponse)
                    }
                } else {
                    success(nil, serviceResponse)
                }
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    /// Use this method to serialize array payload
    func response<SuccessObjectType: Codable>(succeed success: @escaping ([SuccessObjectType]?, ServiceResponse) -> Void,
                                              failed failure: @escaping (ServiceResponse) -> Void,
                                              completed completion: @escaping () -> Void) {
        
        dispatch { (serviceResponse) in
            
            if let _ = serviceResponse.serviceError {
                failure(serviceResponse)
            } else {
                if let data = serviceResponse.data {
                    do {
                        let serializedObject = try JSONDecoder().decode([SuccessObjectType].self, from: data)
                        success(serializedObject, serviceResponse)
                    } catch let parserError {
                        debugPrint("*** parserError ***")
                        debugPrint(parserError)
                        success(nil, serviceResponse)
                    }
                } else {
                    success(nil, serviceResponse)
                }
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
