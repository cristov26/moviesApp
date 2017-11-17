//
//  VideosWebService.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import Foundation
typealias videosClosure = ([Video]?) -> Void

class VideosWebService: BaseService, VideoService{
    static let endPoint = AppConstants.endPoint
    
    func retrieveVideos(movieId: String, completion: @escaping (ServiceResponse) -> Void) {
        
        
        let url = (type(of: self).endPoint + "/movie/" + movieId + "?api_key=\(super.appKey)&append_to_response=videos")
        super.callEndpoint(endPoint: url, completion: completion)
    }
    override func parse(response: AnyObject) -> [AnyObject]? {
        
        return VideosWebService.parse(data: response) as [AnyObject]?
    }
}

private extension VideosWebService{
    
    
    static func parse(data: AnyObject) -> [Video]? {
        if (data is NSDictionary) {
            
            guard let feed = data[VideosServiceParseConstants.videos] as? NSDictionary,
                let videos = feed[VideosServiceParseConstants.results] as? [NSDictionary]
            else {
                    return nil
            }
            return videos.enumerated().map(parseVideos).filter { $0 != nil }.map { $0! }
        }
        return nil
    }
    
    static func parseVideos(rank: Int, data: NSDictionary) -> Video? {
        guard let id = data.value(forKeyPath: VideosServiceParseConstants.id) as? String else {
            return nil
        }
        
        guard let key = data.value(forKeyPath: VideosServiceParseConstants.key) as? String else {
            return nil
        }
        
        guard let site = data.value(forKeyPath: VideosServiceParseConstants.site) as? String else {
            return nil
        }
        return RawVideo(id: id,
                        key: key,
                        site: site)

    }
}
