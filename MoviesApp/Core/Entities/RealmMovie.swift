//
//  RealmMovie.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import Foundation
import RealmSwift


class RealmGenres: Object {
    @objc dynamic var r_genres: String?
    let owners = LinkingObjects(fromType: RealmMovie.self, property: "r_genres")
}

class RealmMovie:Object {
    @objc dynamic var r_movieId: String?
    @objc dynamic var r_title: String?
    @objc dynamic var r_language: String?
    @objc dynamic var r_overview: String?
    @objc dynamic var r_posterPath: String?
    @objc dynamic var r_backdropPath: String?
    @objc dynamic var r_voteAverage: String?
    @objc dynamic var r_voteCount: String?
    let r_genres = List<RealmGenres>()
    @objc dynamic var r_releaseDateString: String?
    @objc dynamic var r_popularity: String?
    @objc dynamic var r_timestamp: NSDate?
    override static func primaryKey() -> String? {
        return "r_movieId"
    }
   
}

extension RealmMovie{
    var movieId: String { return r_movieId! }
    var title: String { return r_title! }
    var language: String { return r_language! }
    var overview: String? { return r_overview! }
    var posterPath: String? { return r_posterPath! }
    var backdropPath: String? { return r_backdropPath! }
    var voteAverage: Float? { return Float(r_voteAverage!) }
    var voteCount: Int? { return Int(r_voteCount!) }
    var releaseDateString: String? { return r_releaseDateString! }
    var popularity: Float? { return Float(r_popularity!) }
    var timestamp: NSDate { return r_timestamp! }
    var genres: [Int]? { return getGenres() }

    private func getGenres() -> [Int]? {
        var genres = [Int]()
        for genre in r_genres {
            genres.append(Int(genre.r_genres!)!)
        }
        return genres.count > 0 ? genres : nil
    }

}

