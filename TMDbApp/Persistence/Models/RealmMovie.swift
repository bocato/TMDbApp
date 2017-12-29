//
//  RealmMovie.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 29/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation
import RealmSwift

class RealmMovie: Object {
    
    // MARK: - Properties
    @objc dynamic var voteCount = 0
    @objc dynamic var id = 0
    @objc dynamic var video = false
    @objc dynamic var videoAverage = 0.0
    @objc dynamic var title: String? = nil
    @objc dynamic var popularity = 0.0
    @objc dynamic var posterPath: String? = nil
    @objc dynamic var originalLanguage: String? = nil
    @objc dynamic var originalTitle: String? = nil
//    @objc dynamic var genreIds = List<Int>()
    @objc dynamic var backdropPath: String? = nil
    @objc dynamic var adult = false
    @objc dynamic var overvie: String? = nil
    @objc dynamic var releaseDate: String? = nil
    
}
