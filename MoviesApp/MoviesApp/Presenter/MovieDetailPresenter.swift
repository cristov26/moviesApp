//
//  MovieDetailPresenter.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import Foundation

final class MovieDetailPresenter{
    
    fileprivate let locator: MoviesUseCaseLocatorProtocol
    let movie: MovieData
    var videos: [Video] = [Video]()
    var title: String
    
    
    init(movie: MovieData, locator: MoviesUseCaseLocatorProtocol) {
        self.movie = movie
        self.locator = locator
        self.title = movie.title
    }
    
    func loadVideos(completion: @escaping videosClosure){
        guard let useCase = self.locator.getUseCase(ofType: ListVideos.self) else {
            return
        }
        useCase.execute (movieId: "\(self.movie.movieId)", completion: { [unowned self] (data) in
            if let vids = data, vids.count > 0 {
                self.videos.append(contentsOf: vids)
            }
            
            completion(data)
        })
        
        
    }
    
}
