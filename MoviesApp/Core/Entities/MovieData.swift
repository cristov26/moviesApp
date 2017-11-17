//
//  AppData.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import Foundation

protocol MovieData {
    
    var movieId: Int { get }
    var title: String { get }
    var language: String? { get }
    var overview: String? { get }
    var posterPath: String? { get }
    var backdropPath: String? { get }
    var voteAverage: Float? { get }
    var voteCount: Int? { get }
    var genres: [Int]? { get }
    var popularity: Float? { get }
    var releaseDateString: String? { get }
    
    

}

struct RawMovieData: MovieData{
    
    let movieId: Int
    let title: String
    let language: String?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Float?
    let voteCount: Int?
    let genres: [Int]?
    let popularity: Float?
    let releaseDateString: String?

}
