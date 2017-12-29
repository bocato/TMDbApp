//
//  FavoriteMoviesDatabaseManager.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 29/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//
import UIKit
import RealmSwift

class FavoriteMoviesDatabaseManager {
    
    // MARK: Singleton
    static let shared = FavoriteMoviesDatabaseManager()
    
    // MARK: Properties
    fileprivate var database: Realm?
    
    fileprivate init() {
        database = try? Realm()
    }
    
    // MARK: Crud
//    func listAll() -> Results<RealmMovie> {
//        guard let database = database else  { return Results<RealmMovie>() }
//        let results: Results<RealmMovie> = database.objects(RealmMovie.self)
//        return results
//    }
//    
//    func addOrUpdate(realmMovie: RealmMovie) {
//        guard let database = database else { return }
//        do {
//            try database.write {
//                database.add(realmMovie, update: true)
//            }
//        } catch error {
//            throw error
//        }
//    }
//    
//    func remove(realmMovie: RealmMovie) {
//        guard let database = database else { return }
//        do {
//            try database.write {
//                database.delete(realmMovie)
//            }
//        } catch error {
//            throw error
//        }
//    }
    
}
