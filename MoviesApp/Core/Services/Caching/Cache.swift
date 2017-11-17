//
//  Cache.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import Foundation
import RealmSwift


enum RefreshInterval: Int {
    case twentySeconds  =      20
    case oneMinute      =      60
    case twoMinutes     =     120
    case fiveMinutes    =     300
    case halfHour       =    1800   // 30 minutes
    case oneHour        =    3600   // 60 minutes
    case oneDay         =   86400   // 24 hours
    case oneWeek        =  604800   //  7 days
    case oneMonth       = 2592000   // 30 days
}

protocol Cache {
    static func objects() -> ([Any]?, Bool)
    static func objects(orderBy: String, predicateFormat: String, _ args: Any...) -> ([Any]?, Bool)
    
    static func add(object: Any)
    static func delete(object: Object)
    
    static func clear()
}

struct CacheImpl: Cache {
    
    static func objects() -> ([Any]?, Bool) {
        return objects(orderBy: "", predicateFormat: "", "")
    }
    
    static func objects(orderBy keyPath: String, predicateFormat: String, _ args: Any...) -> ([Any]?, Bool) {
        guard let realm = try? Realm() else {
            return (nil, true)
        }
        
        var realmObjects: [Any]?
        if predicateFormat.characters.count > 0 {
            realmObjects = Array(realm.objects(RealmMovie.self).filter(predicateFormat, args).sorted(byKeyPath: keyPath, ascending: false))
        }
        else {
            realmObjects = Array(realm.objects(RealmMovie.self).sorted(byKeyPath: keyPath, ascending: false))
        }
        
        return getModelObjects(realmObjects: realmObjects)
    }
    
    static func add(object: Any) {
        guard let realm = try? Realm() else {
            return
        }
        
        try! realm.write {
            
                let realmObj = RealmMovie()
                let modelObj = object as! MovieData
                
                realmObj.r_movieId = "\(modelObj.movieId)"
                realmObj.r_title = modelObj.title
                realmObj.r_language = modelObj.language
                realmObj.r_overview = modelObj.overview
                realmObj.r_posterPath = modelObj.posterPath
                realmObj.r_backdropPath = modelObj.backdropPath
                realmObj.r_voteAverage = "\(modelObj.voteAverage ?? 0.0)"
                realmObj.r_voteCount = "\(modelObj.voteCount ?? 0)"
                if let genres = modelObj.genres {
                CacheImpl.saveGenres(realmObj: realmObj, genres: genres)
                }
                realmObj.r_releaseDateString = modelObj.releaseDateString
                realmObj.r_popularity = "\(modelObj.popularity ?? 0.0)"
                realmObj.r_timestamp = NSDate()

                realm.add(realmObj, update: true)
                
            
        }
    }
    
    static func delete(object: Object) {
        guard let realm = try? Realm() else {
            return
        }
        
        try! realm.write {
            realm.delete(object)
        }
    }
    static func clear() {
        guard let realm = try? Realm() else {
            return
        }
        try! realm.write {
            realm.deleteAll()
        }
    }
}

private extension CacheImpl {

    
    static func saveGenres(realmObj: RealmMovie, genres: [Int]) {
        guard let realm = try? Realm() else {
            return
        }
        
        for strAccessibility in genres {
            let realmGenres = RealmGenres()
            realmGenres.r_genres = String(strAccessibility)
            
            if realm.isInWriteTransaction {
                realm.add(realmGenres)
                realmObj.r_genres.append(realmGenres)
            }
            else {
                try! realm.write {
                    realm.add(realmGenres)
                    realmObj.r_genres.append(realmGenres)
                }
            }
        }
    }
    
    static func checkForExpiration(date: NSDate, expirationInterval interval: RefreshInterval, currentValue: Bool) -> Bool {
        return currentValue ? currentValue : (date.addingTimeInterval(TimeInterval(interval.rawValue)) as Date) <= Date()
    }
    
    static func getModelObjects(realmObjects: [Any]?) -> ([Any]?, Bool) {
        if realmObjects == nil || realmObjects?.count == 0 {
            return (nil, true)
        }
        
        var modelObjects = [Any]()
        var hasToUpdate = false
        
            for item in realmObjects! {
                let realmObj = item as! RealmMovie
                var refreshInterval: RefreshInterval
                
                // TODO: Set this based on what backend says
                refreshInterval = .oneDay
                
                
                hasToUpdate = checkForExpiration(date: realmObj.timestamp, expirationInterval: refreshInterval, currentValue: hasToUpdate)
                
                
                let movie = RawMovieData(movieId: Int(realmObj.movieId)!,
                                           title: realmObj.title,
                                           language: realmObj.language,
                                           overview: realmObj.overview,
                                           posterPath: realmObj.posterPath,
                                           backdropPath: realmObj.backdropPath,
                                           voteAverage: realmObj.voteAverage,
                                           voteCount: realmObj.voteCount,
                                           genres: realmObj.genres,
                                           popularity: realmObj.popularity,
                                           releaseDateString: realmObj.releaseDateString)
                modelObjects.append(movie)

                
            }
         
        return modelObjects.count > 0 ? (modelObjects, hasToUpdate) : (nil, true)
    }

}
