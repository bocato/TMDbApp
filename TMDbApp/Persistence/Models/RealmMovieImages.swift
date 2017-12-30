//
//  RealmMovieImages.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 30/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import RealmSwift
import Realm

class RealmMovieImages: Object {
    
    // MARK: - Properties
    @objc dynamic var movieId: Int = 0
    @objc dynamic var posterPath = ""
    @objc dynamic var backdropPath = ""
    
    override init(value: Any) {
        super.init(value: value)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(realm: value as! RLMRealm, schema: schema.objectSchema.first!) // TODO: Check this... Possible crash here
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init() {
        super.init()
    }
    
    /**
     Override Object.primaryKey() to set the model’s primary key. Declaring a primary key allows objects to be looked up and updated efficiently and enforces uniqueness for each value.
     */
    override static func primaryKey() -> String? {
        return "movieId"
    }
    
}
