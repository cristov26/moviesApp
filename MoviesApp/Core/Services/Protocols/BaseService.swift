//
//  BaseService.swift
//  excalibur
//
//  Created by Nicolas Porpiglia on 3/11/17.
//  Copyright © 2017 rccl. All rights reserved.
//

import UIKit
import Alamofire

// TODO: Override this protocol in all the Services that need it
protocol ProductKey {
    var kProductsArrayKey: String { get }
}

class BaseService : Service, ProductKey {
    
    
    public var kProductsArrayKey: String {
        return ""
    }
    
    // Different result codes
    let successCode = 200
    let productsArray: String = "product"
    
    func callEndpoint (endPoint: String, completion:@escaping (ServiceResponse) -> Void) {
        Alamofire.request(endPoint).responseString { (response) in
            
            var json: [String:AnyObject]?
            if let data = response.result.value?.data(using: String.Encoding.utf8) {
                do {
                    json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                } catch {
                    self.failure(completion: completion)
                }
            }
            
            guard let urlResponse = response.response else {
                if let error = response.result.error as? NSError, error.code == NSURLErrorNotConnectedToInternet {
                    self.notConnectedToInternet(completion: completion)
                } else {
                    self.failure(completion: completion)
                }
                return
            }
            guard let jsonResponse = json else {
                 self.failure(completion: completion)
                return
            }
            switch urlResponse.statusCode {
            case self.successCode:
                self.success(result: self.parse(response: jsonResponse as AnyObject)!, completion: completion)
            case NSURLErrorNotConnectedToInternet:
                self.notConnectedToInternet(completion: completion)
            default:
                self.failure(completion: completion)
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

