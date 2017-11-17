//
//  MoviesRepository.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import Foundation

typealias MoviesClosure = ([MovieData]?) -> Void
enum SaveStatus {
    case success
    case failure
}

struct MoviesCategories {
   static let popularity = "r_popularity"
   static let topRated = "r_voteAverage"
   static let upcoming = "r_releaseDateString"
}

class MoviesRepository: Repository{
    
    let moviesWebService = MovieDBWebService()
    
    internal var lastSyncDate: Date? {
        get {
            return nil
        }
    }
    
    func findMovie(MovieId: String) -> MovieData? {
        let (movies, _) = CacheImpl.objects(orderBy: "r_movieId", predicateFormat: "r_movieId = '%@'", MovieId)
        let movie = movies as? MovieData
        return movie
    }
    
    func listMovies(Page:Int, category: MovieStoreCategory, completion: @escaping MoviesClosure) {
        var movies: [Any]?
        var hasToUpdate: Bool
        var order: String = ""
        switch category {
        case .Popular:
            order = MoviesCategories.popularity
        case .TopRated:
            order = MoviesCategories.topRated
        case .Upcoming:
            order = MoviesCategories.upcoming
        }
        (movies, hasToUpdate) = CacheImpl.objects(orderBy: order, predicateFormat: "")
        
        if hasToUpdate || (movies?.count)!<Page*20 {
            MovieDBWebService.currentPage = Page
            moviesWebService.retrieveMovies(Category: category, completion: { [unowned self] (response) in
                self.handleWebServiceResponse(response: response, completion: completion)
            })
        }
        else {
            completion(movies as? [MovieData])
        }
    }
}
private extension MoviesRepository{
    func handleWebServiceResponse(response: ServiceResponse, completion: @escaping MoviesClosure) {
        var result = [MovieData]()
        
        switch response {
        case .success(let Movies):
            for Movie in Movies {
                CacheImpl.add(object: Movie as! MovieData)
                result.append(Movie as! MovieData)
            }
            completion(result)
        case .notConnectedToInternet:
            print("notConnectedToInternet")
            completion(result)
        case .failure:
            print("failure")
            completion(result)
        }
    }
}
