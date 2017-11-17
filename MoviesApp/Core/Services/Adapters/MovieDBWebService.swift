//
//  MovieDBWebService.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import Foundation
import Alamofire

class MovieDBWebService: BaseService, MovieStoreService {
    static let endPoint = AppConstants.endPoint
    static var currentPage = 1;
  
    func retrieveMovies(Category: MovieStoreCategory, completion: @escaping (ServiceResponse) -> Void) {
        
        
        let url = (type(of: self).endPoint + "/discover/movie?" + "page=\(type(of: self).currentPage)" + "&sort_by=\(Category.rawValue)" + "&api_key=\(super.appKey)")
        super.callEndpoint(endPoint: url, completion: completion)
    }
    
    override func parse(response: AnyObject) -> [AnyObject]? {
        let movies =  MovieDBWebService.parse(data: response) as [AnyObject]?
        return movies
    }
}

// MARK: Parsing

private extension MovieDBWebService {
   
    static func parse(data: AnyObject) -> [MovieData]? {
        if (data is NSDictionary) {

        guard let feed = data[MoviesParseConstants.results] as? [NSDictionary]
            else {
                return nil
        }
        return feed.enumerated().map(parseMovie).filter { $0 != nil }.map { $0! }
        }
        return nil
    }
    
    static func parseMovie(rank: Int, data: NSDictionary) -> MovieData? {
        guard let movieId = data.value(forKeyPath: MoviesParseConstants.Id) as? Int else {
            return nil
        }
        guard let title = data.value(forKeyPath: MoviesParseConstants.originalTitle) as? String else {
            return nil
        }
        
        return RawMovieData(movieId: movieId,
                          title: title,
                          language: (data.value(forKeyPath: MoviesParseConstants.originalLanguage) as? String) ?? "",
                          overview: (data.value(forKeyPath: MoviesParseConstants.overview) as? String) ?? "",
                          posterPath: (data.value(forKeyPath: MoviesParseConstants.posterPath) as? String) ?? "",
                          backdropPath: (data.value(forKeyPath: MoviesParseConstants.backdropPath) as? String) ?? "",
                          voteAverage: (data.value(forKeyPath: MoviesParseConstants.voteAverage) as? Float) ?? 0.0,
                          voteCount: (data.value(forKeyPath: MoviesParseConstants.voteCount) as? Int) ?? 0,
                          genres: (data.value(forKeyPath: MoviesParseConstants.genreIds) as? [Int] ?? []),
                          popularity: (data.value(forKeyPath: MoviesParseConstants.popularity) as? Float) ?? 0.0,
                          releaseDateString: (data.value(forKeyPath: MoviesParseConstants.releaseDate) as? String) ?? "")
    }
}
