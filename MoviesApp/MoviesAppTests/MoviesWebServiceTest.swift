//
//  MoviesWebServiceTest.swift
//  
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import XCTest
@testable import MoviesApp

//This test has the purpose to test the model, service, parse, and caching layer
class MoviesWebServiceTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMoviesWebService(){
        let service = MovieDBWebService()
        let serviceExpectation = self.expectation(description: "MoviesWebServiceExpectation")
        service.retrieveMovies(Category: MovieStoreCategory.Upcoming, completion: { (response) in
        
            switch response {
            case .success(let movies):
                if movies.count != 20 {
                    XCTAssert(false, "The web service request succeeded but it should bring exactly 20 movies")
                }
                
            case .notConnectedToInternet:
                XCTAssert(false,"The web service failed with error: notConnectedToInternet")
                
            case .failure:
                XCTAssert(false,"The web service request failed")

            }
            serviceExpectation.fulfill()

        })
        self.waitForExpectations(timeout: 10.0, handler: nil)
    }
    func testVideosWebService(){
        let movieID = "321612"
        let service = VideosWebService()
        let serviceExpectation = self.expectation(description: "VideosWebServiceExpectation")
        service.retrieveVideos(movieId: movieID, completion: { (response) in
            
            switch response {
            case .success(let videos):
                if videos.count == 0 {
                    XCTAssert(false, "The web service request succeeded but it should bring at least 1 video")
                }
                
            case .notConnectedToInternet:
                XCTAssert(false,"The web service failed with error: notConnectedToInternet")
                
            case .failure:
                XCTAssert(false,"The web service request failed")
                
            }
            serviceExpectation.fulfill()
            
        })
        self.waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    
}
