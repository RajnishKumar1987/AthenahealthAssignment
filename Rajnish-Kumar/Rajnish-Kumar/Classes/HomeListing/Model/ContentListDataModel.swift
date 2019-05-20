//
//  ContentListDataModel.swift
//  Rajnish-Kumar
//
//  Created by Rajnish Kumar on 18/05/19.
//  Copyright © 2019 Rajnish Kumar. All rights reserved.
//

import Foundation

struct ContentListDataModel: Codable {
    
    var feed: Feed?
    
    init() {
    }
}

struct Feed: Codable {
    var title: String?
    var results: [Content]?
}

struct Content:Codable {
    var artistName: String?
    var id: String?
    var releaseDate: String?
    var name: String?
    var kind: String?
    var copyright: String?
    var artistId: String?
    var artistUrl: String?
    var artworkUrl100: String?
    var url: String?
    var genres: [Genres]?
    
}

struct Genres: Codable {
    var genreId: String?
    var name: String?
    var url: String?
    
}
