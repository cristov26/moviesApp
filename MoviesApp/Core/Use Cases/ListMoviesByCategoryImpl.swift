//
//  ListMoviesByCategoryImpl.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import Foundation

class ListMoviesByCategoryImpl: UseCaseImpl, ListMoviesByCategory{
    func execute(page: Int, category: MovieStoreCategory, completion: @escaping MoviesClosure) {
        repository.listMovies(Page: page, category: category, completion: { (moviesData) in
            completion(moviesData)
        })
    }
}
