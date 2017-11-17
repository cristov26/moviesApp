//
//  listMoviesTest.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import XCTest
@testable import MoviesApp

class listMoviesTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testListMovies() {
        
        let mockRepository = InMemoryMoviesRepository()
        let movie1 = buildMovie(movieId: 1, title: "Movie 1")
        let movie2 = buildMovie(movieId: 2, title: "Movie 2")
        
        mockRepository.save(movies: [movie1, movie2]) { (status) in
            
            let locator = MoviesUseCaseLocator(repository: mockRepository, service: MovieDBWebService())
            let implementation = locator.getUseCase(ofType: ListMoviesByCategory.self)
            
            implementation?.execute(page: 0, category: MovieStoreCategory.Popular, completion: { (listMovies) in
                XCTAssertEqual(listMovies?.count, 2, "Two Mock Saved")
                XCTAssertEqual(listMovies?.first?.movieId, movie1.movieId, "Movie 1 comes first")
                XCTAssertEqual((listMovies?.first!)?.title, movie1.title, "Movie 1 title")
            })
        }
        
    }
    
}
private extension listMoviesTest {
    func buildMovie(movieId: Int, title: String) -> MovieData {
        return RawMovieData(movieId: movieId,
                            title: title,
                            language: nil,
                            overview: nil,
                            posterPath: nil,
                            backdropPath: nil,
                            voteAverage: nil,
                            voteCount: nil,
                            genres: nil,
                            popularity: nil,
                            releaseDateString: nil)
 
    }
}
