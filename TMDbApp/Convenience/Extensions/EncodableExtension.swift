//
//  EncodableExtension.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 30/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

extension Encodable {
    
    var dictionaryValue: Dictionary<String, Any>? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else {
            return nil
        }
        
        do {
            let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return jsonDictionary as? [String: Any]
        } catch {
            return nil
        }
    }
    
}
