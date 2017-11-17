//
//  VideoService.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import Foundation

protocol VideoService {
    func retrieveVideos(movieId: String, completion: @escaping (ServiceResponse) -> Void)
}
