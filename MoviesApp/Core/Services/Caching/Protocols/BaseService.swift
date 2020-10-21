//
//  BaseService.swift
//  
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import Alamofire

// TODO: Override this protocol in all the Services that need it

enum ServiceResponse {
    case failure
    case notConnectedToInternet
    case success(response: [AnyObject])
}

class BaseService {
    let appKey = "4613442500106debd35a2a2dc8241956"
    public var kProductsArrayKey: String {
        return ""
    }
    
    // Different result codes
    let successCode = 200
    
    func callEndpoint (endPoint: String, completion:@escaping (ServiceResponse) -> Void) {
        AF.request(endPoint).responseJSON { (response) in
            
            switch response.result {
            case let .success(jsonValue):
                self.success(result: self.parse(response: jsonValue as AnyObject)!, completion: completion)
            case .failure(_):
                if response.response?.statusCode == NSURLErrorNotConnectedToInternet {
                    self.notConnectedToInternet(completion: completion)
                } else {
                    self.failure(completion: completion)
                }
            }
           
        }
    }
    
    /**
     * Parse method
     * Pure virtual, this is intended to be overrided with a custom parsing method
     * @param: {String} completion - Initial block with response
     */
    
    func parse (response: AnyObject) -> [AnyObject]? {
        return nil
    }
    
    /**
     * Not connected method
     * Override as needed, this provides a default implementation for the 'No Connection' result
     * @param: {String} completion - Initial block with response
     */
    func notConnectedToInternet (completion:@escaping (ServiceResponse) -> Void) {
        completion(.notConnectedToInternet)
    }
    
    /**
     * Failure method
     * Override as needed, this provides a default implementation for the failure result
     * @param: {String} completion - Initial block with response
     */
    
    func failure (completion:@escaping (ServiceResponse) -> Void) {
        completion(.failure)
    }
    
    /**
     * Success method
     * Override as needed, this provides a default implementation for the success result
     * @param: {String} result - Parsing result
     * @param: {String} completion - Initial block with response
     */
    
    func success (result: [AnyObject], completion:@escaping (ServiceResponse) -> Void) {
        completion(.success(response: result))
    }
}

