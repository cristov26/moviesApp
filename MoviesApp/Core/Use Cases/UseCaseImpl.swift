//
//  UseCaseImpl.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import Foundation

class UseCaseImpl {
    let repository: Repository
    let service: BaseService
    
    required init(repository: Repository, service: BaseService) {
        self.repository = repository
        self.service = service
    }
}
