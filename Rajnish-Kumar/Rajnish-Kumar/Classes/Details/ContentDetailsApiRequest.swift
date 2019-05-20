//
//  ContentDetailsApiRequest.swift
//  Rajnish-Kumar
//
//  Created by Rajnish Kumar on 18/05/19.
//  Copyright © 2019 Rajnish Kumar. All rights reserved.
//

import Foundation

class ContentDetailsApiRequest: APIRequest {
    
    public init() {
        
    }
    public func makeRequest(requestType: HTTPMethod, function: ApiEndPoint, parameters: Dictionary<String,String>? = [:], requestHeaders: HTTPHeaders?) throws -> URLRequest {
        let url = try URLEncoder().urlWith(urlString: function.urlString, parameters: parameters)
        var urlRequest = URLRequest(url:url)
        urlRequest.httpMethod = requestType.rawValue
        addAdditionalHeaders(requestHeaders, request: &urlRequest)
        return urlRequest
    }
    
    public func parseResponse(data: Data) throws -> ContentDetailsDataModel {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(ContentDetailsDataModel.self, from: data)
    }
}
