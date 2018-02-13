//
//  ApplicationData.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

class ApplicationData {
    
    // MARK: - Singleton
    static let shared = ApplicationData()
    
    // MARK: Properties
    var movieGenres: [Genre]?
    
    // MARK: Computed Properties
    static var favoriteMovies: [Movie]? {
        return FavoriteMoviesDatabaseManager.shared.listAll()?.flatMap({ (realmMovie) -> Movie? in
            let tmdbMovie = realmMovie.asTMDbMovie()
            return tmdbMovie
        })
    }
    
    // MARK: HelperMethods
    static func isThisMovieAFavorite(_ movie: Movie!) -> Bool {
        guard let favoriteMovies = ApplicationData.favoriteMovies else {
            return false
        }
        return favoriteMovies.contains(movie)
    }
    
}
