//
//  UseCaseLocator.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import Foundation

protocol MoviesUseCaseLocatorProtocol {
    func getUseCase<T>(ofType type: T.Type) -> T?
}

class MoviesUseCaseLocator: MoviesUseCaseLocatorProtocol {
    
    static let defaultLocator = MoviesUseCaseLocator(repository: MoviesRepository(),
                                                       service: MovieDBWebService())
    
    fileprivate let service: BaseService
    fileprivate let repository: Repository
    
    init(repository: Repository, service: BaseService) {
        self.repository = repository
        self.service = service
    }
    
    func getUseCase<T>(ofType type: T.Type) -> T? {
        switch String(describing: type) {
        case String(describing: ListMoviesByCategory.self):
            return buildUseCase(type: ListMoviesByCategoryImpl.self)
        case String(describing: ListVideos.self):
            return buildUseCase(type: ListVideosImpl.self)
        default:
            return nil
        }
    }
}

private extension MoviesUseCaseLocator {
    func buildUseCase<U: UseCaseImpl, R>(type: U.Type) -> R? {
        return U(repository: repository, service: service) as? R
    }
}
