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
    
//    func addToFavorites(_ movie: Movie!, onSuccess success: @escaping () -> (), onFailure failure: ((RealmError?) -> Void)? = nil) {
//        guard let _ = favoriteMovies else {
//            let realmMovie = RealmMovie(value: movie.dictionaryValueForRealm as Any)
//            FavoriteMoviesDatabaseManager.shared.addOrUpdate(realmMovie: realmMovie)
//            return true
//        }
//        if self.favoriteMovies!.contains(movie) {
//            return false
//        } else {
//            let realmMovie = RealmMovie(value: movie.dictionaryValueForRealm as Any)
//            FavoriteMoviesDatabaseManager.shared.addOrUpdate(realmMovie: realmMovie)
//            return true
//        }
//    }
    
//    func removeFromFavorites(_ movie: Movie!, onSuccess success: @escaping () -> (), onFailure failure: ((RealmError?) -> Void)? = nil) {
//        guard let _ = favoriteMovies, let movieId = movie.id else {
//            return false
//        }
//        FavoriteMoviesDatabaseManager.shared.deleteMovie(with: movieId)
//        return true
//    }
    
    // MARK: HelperMethods
    static func isThisMovieAFavorite(_ movie: Movie!) -> Bool {
        guard let favoriteMovies = ApplicationData.favoriteMovies else {
            return false
        }
        return favoriteMovies.contains(movie)
    }
    
}
