//
//  Videos.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import Foundation

protocol Video {
    var id: String { get }
    var key: String { get }
    var site: String { get }
}

struct RawVideo: Video {
    let id: String
    let key: String
    let site: String
}
