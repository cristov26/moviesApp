//
//  
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//


import Foundation

final class MoviesPresenter{

    fileprivate let locator: MoviesUseCaseLocatorProtocol
    
    let title: String
    var movies: [MovieData] = [MovieData]()
    var filteredMovies: [MovieData]
    var currentCategory: MovieStoreCategory? = nil
    let categories = [MovieStoreCategory.Popular, MovieStoreCategory.TopRated, MovieStoreCategory.Upcoming]

    
    var defaultCategory: String {
        get{
            return categories[0].rawValue
        }
    }
    
    var emptyDataMessage: String {
        get {
            let messageString = AppConstants.noMoviesMessage
            return messageString
        }
    }
    
    init(locator: MoviesUseCaseLocatorProtocol) {
        self.locator = locator
        self.title = "Movies"
        self.filteredMovies = []
    }
    
    func loadMovies(completion: @escaping MoviesClosure) {
        guard let useCase = self.locator.getUseCase(ofType: ListMoviesByCategory.self) else {
            return
        }
        let actualPage = self.movies.count/20
        let nextPage = actualPage+1
        useCase.execute (page: nextPage, category: currentCategory!, completion: { [unowned self] (data) in
            if let movies = data, movies.count > 0 {
                self.movies.append(contentsOf: movies)
            }
            
            completion(data)
        })
    }
    
    func filterProductsByCurrentCategory () {
        if currentCategory == MovieStoreCategory.Popular {
            movies = movies.sorted{ Float($0.popularity!) > Float($1.popularity!) }
            
        }
        else if currentCategory == MovieStoreCategory.TopRated {
            movies = movies.sorted{ Float($0.voteAverage!) > Float($1.voteAverage!) }
        }
        else if currentCategory == MovieStoreCategory.Upcoming {
            movies = movies.sorted{ $0.releaseDateString! > $1.releaseDateString! }
        }
    }
    
}
