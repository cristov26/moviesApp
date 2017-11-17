//
//  MovieStoreService.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import Foundation



enum MovieStoreCategory: String {
    case Popular = "popularity.desc"
    case TopRated = "vote_average.desc"
    case Upcoming = "release_date.desc"
}

protocol MovieStoreService {
    static var currentPage: Int {get set}
    func retrieveMovies(Category: MovieStoreCategory, completion: @escaping (ServiceResponse) -> Void)
}
