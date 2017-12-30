//
//  RealmMovie.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 29/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class RealmMovie: Object {
    
    // MARK: - Properties
    @objc dynamic var voteCount: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var video = false
    @objc dynamic var videoAverage: Float = 0.0
    @objc dynamic var title = ""
    @objc dynamic var popularity: Float = 0.0
    @objc dynamic var posterPath = ""
    @objc dynamic var originalLanguage = ""
    @objc dynamic var originalTitle = ""
    let genreIds = List<Int>()
    @objc dynamic var backdropPath = ""
    @objc dynamic var adult: Bool = false
    @objc dynamic var overview = ""
    @objc dynamic var releaseDate = ""
    
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
        return "id"
    }
    
}

extension RealmMovie {
    
    func asTMDbMovie() -> Movie? {
        
        var genreIds = [Int]()
        for genreId in self.genreIds {
            genreIds.append(genreId)
        }
        
        return Movie(voteCount: voteCount, id: id, video: video, videoAverage: videoAverage, title: title, popularity: popularity, posterPath: posterPath, originalLanguage: originalLanguage, originalTitle: originalTitle, genreIds: genreIds, backdropPath: backdropPath, adult: adult, overview: overview, releaseDate: releaseDate)
    }
    
}
