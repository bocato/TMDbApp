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
    
    // TODO: Remove this and use realm or firebase
    var favoriteMovies: [Movie]?
    
    func addToFavorites(_ movie: Movie!) -> Bool {
        guard let _ = favoriteMovies else {
            self.favoriteMovies = [Movie]()
            self.favoriteMovies?.append(movie)
            return true
        }
        if self.favoriteMovies!.contains(movie) {
            return false
        } else {
            self.favoriteMovies?.append(movie)
            return true
        }
    }
    
    func removeFromFavorites(_ movie: Movie!) -> Bool {
        guard let _ = favoriteMovies, let index = self.favoriteMovies?.index(of: movie) else {
            return false
        }
        favoriteMovies!.remove(at: index)
        return true
    }
    
    func isThisMovieAFavorite(_ movie: Movie!) -> Bool {
        guard let favoriteMovies = favoriteMovies else {
            return false
        }
        return favoriteMovies.contains(movie)
    }
    
}
