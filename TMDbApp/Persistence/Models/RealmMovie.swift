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
    var voteCount = RealmOptional<Int>()
    var id = RealmOptional<Int>()
    @objc dynamic var video: Bool = false
    var videoAverage = RealmOptional<Float>()
    @objc dynamic var title: String = ""
    var popularity = RealmOptional<Float>()
    @objc dynamic var posterPath: String = ""
    @objc dynamic var originalLanguage: String = ""
    @objc dynamic var originalTitle: String = ""
    let genreIds = List<Int>()
    @objc dynamic var backdropPath: String = ""
    var adult: Bool = false
    @objc dynamic var overview: String = ""
    @objc dynamic var releaseDate: String = ""
    
    
//    var voteCount: Int?
//    var id: Int?
//    var video: Bool = false
//    var videoAverage: Float?
//    var title: String?
//    var popularity: Float?
//    var posterPath: String?
//    var originalLanguage: String?
//    var originalTitle: String?
//    var genreIds: [Int]?
//    var backdropPath: String?
//    var adult: Bool = false
//    var overview: String?
//    var releaseDate: String?
    
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
        
        return Movie(voteCount: voteCount.value, id: id.value, video: video, videoAverage: videoAverage.value, title: title, popularity: popularity.value, posterPath: posterPath, originalLanguage: originalLanguage, originalTitle: originalTitle, genreIds: genreIds, backdropPath: backdropPath, adult: adult, overview: overview, releaseDate: releaseDate)
    }
    
}
