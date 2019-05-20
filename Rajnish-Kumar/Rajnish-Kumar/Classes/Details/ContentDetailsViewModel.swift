//
//  ContentDetailsViewModel.swift
//  Rajnish-Kumar
//
//  Created by Rajnish Kumar on 18/05/19.
//  Copyright © 2019 Rajnish Kumar. All rights reserved.
//

import Foundation

class ContentDetailsViewModel {
    
    let apiLoader: APIRequestLoader<ContentDetailsApiRequest>!
    var contentId: String
    var dataModel = AlbumDetailsModel()
    
    
    init(with contentId: String, loader: APIRequestLoader<ContentDetailsApiRequest> = APIRequestLoader(apiRequest: ContentDetailsApiRequest())) {
        self.apiLoader = loader
        self.contentId = contentId
    }
    
    func loadContentDetails(result:@escaping(Result<NetworkError>)->Void) {
        
        apiLoader.loadAPIRequest(request: .get, funcion: .getContentDetails(contentId: self.contentId), requestData: nil, requestHeaders: headers) { [weak self] (response, error) in
            
            guard let weakSelf = self else {
                if let error = error{
                    result(.failure(error))
                }
                return
            }
            
            if let response = response {
                
                weakSelf.dataModel = weakSelf.prepareAlbumDetailsModel(model: response)
                result(.success)
                
            }
            else{
                if let error = error{
                    result(.failure(error))
                }
                return
            }
            
        }
        
    }
    
    func prepareAlbumDetailsModel(model: ContentDetailsDataModel ) -> AlbumDetailsModel {
        
        var albumDetailsModel = AlbumDetailsModel()

        if let details = model.details, details.count > 0 {
            let model = details[0]
            albumDetailsModel.id = model.id
            albumDetailsModel.title = model.attributes?.name
            albumDetailsModel.artists = model.attributes?.artistName
            albumDetailsModel.genres = model.attributes?.genreNames?.joined(separator: ", ")
            albumDetailsModel.recordedLabel = model.attributes?.recordLabel
            albumDetailsModel.releaseDate = model.attributes?.releaseDate
            albumDetailsModel.copyRight = model.attributes?.copyright
            if let url = model.attributes?.artwork?.url {
                albumDetailsModel.artworkUrl =  url.replacingOccurrences(of: "{w}", with: "200").replacingOccurrences(of: "{h}", with: "200").replacingOccurrences(of: "jpeg", with: "png")
            }
            
            if let relationships = model.relationships, let trackList = relationships.tracks?.trackList{
                
                albumDetailsModel.tracks = trackList.map({ (track) -> TrackDataModel in
                  
                    var url = ""
                    var hasPreview = false
                    if  let previewURLs = track.attributes?.previews, previewURLs.count > 0, let previewUrl = previewURLs.first?.url{
                        url = previewUrl
                        hasPreview = true
                    }
                    return TrackDataModel(trackNumber: track.attributes?.trackNumber, title: track.attributes?.name, artist: track.attributes?.composerName, duration: track.attributes?.durationInMillis, previewUrl: url, hasPreview: hasPreview)
                })
                
            }
            
        }
        
        return albumDetailsModel
    }
    
    
    let headers = ["Authorization": "Bearer eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IldlYlBsYXlLaWQifQ.eyJpc3MiOiJBTVBXZWJQbGF5IiwiaWF0IjoxNTU2ODM2MDk5LCJleHAiOjE1NzIzODgwOTl9.branji7_TSRC8pMGvWTHgx5FIr23NvIcyuQONYDsJAquOmbcZLdot44ZbEzSpNEOYMztwUxiIE04UtaVmcr_9g",
                   "User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1.2 Safari/605.1.15",
                   "Content-Type":"application/json"]
}

struct TrackDataModel {
    var trackNumber: Int?
    var title: String?
    var artist: String?
    var duration: Int32?
    var previewUrl: String?
    var hasPreview: Bool = false
}

struct AlbumDetailsModel {
    var id: String?
    var title: String?
    var artworkUrl: String?
    var artists: String?
    var genres: String?
    var releaseDate: String?
    var recordedLabel: String?
    var copyRight: String?
    var tracks: [TrackDataModel] = []
}
