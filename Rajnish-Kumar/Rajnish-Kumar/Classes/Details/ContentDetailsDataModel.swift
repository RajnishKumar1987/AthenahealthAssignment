//
//  ContentDetailsDataModel.swift
//  Rajnish-Kumar
//
//  Created by Rajnish Kumar on 18/05/19.
//  Copyright © 2019 Rajnish Kumar. All rights reserved.
//

import Foundation

struct ContentDetailsDataModel: Codable {
    
    var details: [ContentDetails]?
    
    enum CodingKeys: String, CodingKey {
        case details = "data"
    }
}

struct ContentDetails: Codable {
    var id: String?
    var type: String?
    var attributes: Attributes?
    var relationships: Relationships?
}

struct Attributes: Codable {
    var artwork: Artwork?
    var artistName: String?
    var genreNames: [String]?
    var trackCount: Int?
    var releaseDate: String?
    var name: String?
    var recordLabel: String?
    var copyright: String?
    var durationInMillis: Int32?
    var composerName: String?
    var trackNumber: Int?
    var previews: [Previews]?
    
}

struct Artwork: Codable {
    var url: String?
    
}
struct  Relationships: Codable {
    var tracks: Tracks?
}

struct Tracks: Codable {
    var trackList: [Track]?
    
    enum CodingKeys: String, CodingKey {
        case trackList = "data"
    }
}
struct Previews: Codable {
    var url: String?
}
struct Track: Codable {
    var attributes: Attributes?
    
}


