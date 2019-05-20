//
//  ContentListViewModel.swift
//  Rajnish-Kumar
//
//  Created by Rajnish Kumar on 18/05/19.
//  Copyright © 2019 Rajnish Kumar. All rights reserved.
//

import Foundation

class ContentListViewModel {
    
    let apiLoader: APIRequestLoader<ContentListApiRequest>!
    var model = ContentListDataModel()
    var contentType: ContentType
    
    init(with contentType: ContentType, loader: APIRequestLoader<ContentListApiRequest> = APIRequestLoader(apiRequest: ContentListApiRequest())) {
        self.apiLoader = loader
        self.contentType = contentType
    }
    
    func loadContentList(result:@escaping(Result<NetworkError>)->Void) {
        
        
        apiLoader.loadAPIRequest(request: .get, funcion: .getContentList(contentType:self.contentType, itemCount: "20"), requestData: nil, requestHeaders: nil) { [weak self] (response, error) in
            
            guard let weakSelf = self else {
                if let error = error{
                    result(.failure(error))
                }
                return
            }
            
            if let response = response {
               
                weakSelf.model = response
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
    
    
    func getCellCount() -> Int {
        guard let feed = self.model.feed , let result = feed.results else {
            return 0
        }
        return result.count
    }
    
    func getContentCellModel(for indexPath: IndexPath) -> ContentCellModel? {
        
        var model = ContentCellModel()
        
        if let feed = self.model.feed, let result = feed.results, result.count >= indexPath.item  {
            let contentModel = result[indexPath.item]
            model.id = contentModel.id
            model.imageUrl = contentModel.artworkUrl100
            model.title = contentModel.name
            model.artist = contentModel.artistName
        }
        return model
    }
    
}

struct ContentCellModel {
    var id: String?
    var imageUrl: String?
    var title: String?
    var artist: String?
}
