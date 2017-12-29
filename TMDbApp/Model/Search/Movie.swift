//
//  Movie.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

struct Movie: Codable {
    
    // MARK: - Properties
    var voteCount: Int?
    var id: Int?
    var video: Bool = false
    var videoAverage: Float?
    var title: String?
    var popularity: Float?
    var posterPath: String?
    var originalLanguage: String?
    var originalTitle: String?
    var genreIds: [Int]?
    var backdropPath: String?
    var adult: Bool = false
    var overview: String?
    var releaseDate: String?
    
    // MARK: CodingKeys
    enum CodingKeys : String, CodingKey {
        case voteCount = "vote_count"
        case id = "id"
        case video = "video"
        case title = "title"
        case popularity = "popularity"
        case videoAverage = "vote_average"
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIds = "genre_ids"
        case backdropPath = "backdrop_path"
        case adult = "adult"
        case overview = "overview"
        case releaseDate = "release_date"
    }
    
}

extension Movie {
    
    var posterURLString: String? {
        guard let posterPath = posterPath else { return nil }
        return Environment.shared.baseURLForImages + posterPath
    }
    
    var genres: [Genre]? {
        guard let genreIds = self.genreIds else { return nil }
        return genreIds.flatMap({ (id) -> Genre? in
            ApplicationData.shared.movieGenres?.filter( { $0.id == id } ).first
        })
    }
    
    var genresString: String? {
        guard let genres = self.genres else { return nil }
        return genres.flatMap({ (genre) -> String? in
            return genre.name
        }).joined(separator: ", ")
    }
    
}
