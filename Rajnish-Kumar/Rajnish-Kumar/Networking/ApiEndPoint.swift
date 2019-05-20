//
//  Api_EndPoint.swift
//  GetDonor
//
//  Created by Rajnish kumar on 07/09/18.
//  Copyright © 2018 GetDonor. All rights reserved.
//

import Foundation

enum ContentType: String{
    case comingSoon = "coming-soon"
    case hotTracks = "hot-tracks"
    case newRelease = "new-releases"
    case topAlbums = "top-albums"
    case topSongs = "top-songs"
}


enum ApiEndPoint {
    
    case getContentList(contentType: ContentType, itemCount: String)
    case getContentDetails(contentId: String)
    
    var urlString: String{
        switch self {
            
        case .getContentList(let contentType, let itemCount):
            return AppBaseURLs.contentListUrl.appending("/api/\(AppBaseURLs.contentApiVersion)/in/apple-music/\(contentType.rawValue)/all/\(itemCount)/explicit.json")
            
        case.getContentDetails(let contentId):
            return AppBaseURLs.contentDetailsUrl.appending("/\(AppBaseURLs.contentApiVersion)/catalog/IN/albums?ids=\(contentId)")
            
        }
        
    }

}


