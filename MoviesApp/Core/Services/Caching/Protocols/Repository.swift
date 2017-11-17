//
//  Repository.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import Foundation

protocol Repository {
    func listMovies(Page:Int, category: MovieStoreCategory, completion: @escaping MoviesClosure) 

}
