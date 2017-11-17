//
//  ListVideosImpl.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import Foundation

class ListVideosImpl: UseCaseImpl, ListVideos{
    func execute(movieId: String, completion: @escaping videosClosure) {
        (service as! VideosWebService).retrieveVideos(movieId: movieId, completion: { response in
            var result = [Video]()
            
            switch response {
            case .success(let Videos):
                for video in Videos {
                    result.append(video as! Video)
                }
                completion(result)
            case .notConnectedToInternet:
                print("notConnectedToInternet")
                completion(result)
            case .failure:
                print("failure")
                completion(result)
            }
        })
    }
}
