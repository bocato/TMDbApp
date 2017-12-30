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
    
    // MARK: - Constants
    fileprivate static let hasAnyFavoritesKey = "hasAnyFavorites"
    
    // MARK: Singleton
    static let shared = FavoriteMoviesDatabaseManager()
    
    // MARK: Properties
    fileprivate var database: Realm?
    
    // MARK: Initialization
    fileprivate init() {
        database = try? Realm()
    }
    
    // MARK: - Helpers
    func findMovie(with id: Int!) -> RealmMovie? {
        guard let database = database else { return nil }
        let object = database.objects(RealmMovie.self).filter( { $0.id == id } ).first
        if object?.id == id {
            return object
        }
        return nil
    }
    
    func updateHasAnyFavoritesKey(hasAnyFavorites: Bool){
        UserDefaults.standard.set(hasAnyFavorites, forKey: FavoriteMoviesDatabaseManager.hasAnyFavoritesKey)
        UserDefaults.standard.synchronize()
    }
    
    static func hasAnyFavorites() -> Bool {
        return UserDefaults.standard.bool(forKey: FavoriteMoviesDatabaseManager.hasAnyFavoritesKey)
    }
    
    // MARK: CRUD
    func listAll() -> Results<RealmMovie>? {
        guard let database = database else {
            updateHasAnyFavoritesKey(hasAnyFavorites: false)
            return nil
        }
        let results: Results<RealmMovie> = database.objects(RealmMovie.self)
        updateHasAnyFavoritesKey(hasAnyFavorites: results.count > 0)
        return results
    }
    
    func addOrUpdate(realmMovie: RealmMovie, onSuccess success: @escaping () -> (), onFailure failure: ((RealmError?) -> Void)? = nil) {
        guard let database = database else {
            failure?(RealmError(message: PersistenceErrorMessages.invalidDatabase.rawValue, code: PersistenceErrorCodes.invalidDatabase.rawValue))
            return
        }
        do {
            try database.write {
                database.add(realmMovie, update: true)
                success()
            }
        } catch let error {
            debugPrint(error)
            failure?(RealmError(message: PersistenceErrorMessages.couldNotSaveOrUpdateObject.rawValue, code: PersistenceErrorCodes.couldNotSaveOrUpdateObject.rawValue))
        }
    }
    
    func deleteMovie(with id: Int!, onSuccess success: @escaping () -> (), onFailure failure: ((RealmError?) -> Void)? = nil) {
        guard let database = database else {
            failure?(RealmError(message: PersistenceErrorMessages.invalidDatabase.rawValue, code: PersistenceErrorCodes.invalidDatabase.rawValue))
            return
        }
        guard let objectToDelete = self.findMovie(with: id) else {
            failure?(RealmError(message: PersistenceErrorMessages.objectNotFound.rawValue, code: PersistenceErrorCodes.objectNotFound.rawValue))
            return
        }
        do {
            try database.write {
                database.delete(objectToDelete)
                success()
            }
        } catch let error {
            debugPrint(error)
            failure?(RealmError(message: PersistenceErrorMessages.couldNotDeleteObject.rawValue, code: PersistenceErrorCodes.couldNotDeleteObject.rawValue))
        }
    }
    
    func deleteAll(onSuccess success: @escaping () -> (), onFailure failure: ((RealmError?) -> Void)? = nil) {
        guard let database = database else {
            failure?(RealmError(message: PersistenceErrorMessages.invalidDatabase.rawValue, code: PersistenceErrorCodes.invalidDatabase.rawValue))
            return
        }
        do {
            try database.write {
                database.deleteAll()
                updateHasAnyFavoritesKey(hasAnyFavorites: false)
                success()
            }
        } catch let error {
            debugPrint(error)
            failure?(RealmError(message: PersistenceErrorMessages.couldNotDropDatabase.rawValue, code: PersistenceErrorCodes.couldNotDropDatabase.rawValue))
        }
    }
}
