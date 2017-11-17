//
//  InMemoryMoviesRepository.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import Foundation
@testable import MoviesApp


class InMemoryMoviesRepository: Repository {
    
    private var allMovies: [Int: MovieData] = [:]
    
    internal var lastSyncDate: Date?
    
    func save(movies: [MovieData], completion: @escaping (SaveStatus) -> Void) {
        movies.forEach {allMovies[$0.movieId] = $0 }
        lastSyncDate = Date()
        completion(.success)
    }
    
    internal func findProduct(ProductID: String) -> MovieData? {
        return nil
    }
    
    internal func listMovies(Page:Int, category: MovieStoreCategory, completion: @escaping MoviesClosure) {
        let movies = allMovies.map { $0.value }.sorted { $0.0.movieId < $0.1.movieId }
        completion(movies)
    }

}
