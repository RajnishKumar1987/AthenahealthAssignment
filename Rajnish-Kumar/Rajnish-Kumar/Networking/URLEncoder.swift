//
//  File.swift
//  SampleApp
//
//  Created by Rajnish kumar on 14/08/18.
//  Copyright © 2018 Rajnish kumar. All rights reserved.
//

import Foundation

enum URLEncodeingError: Swift.Error {
    case URLStringNotURLConvertable
}

protocol URLEncodeble {
    
    func urlWith(urlString: String, parameters: Dictionary<String, Any>?)throws -> URL
}

class URLEncoder: URLEncodeble {
    
    func urlWith(urlString: String, parameters: Dictionary<String, Any>?) throws -> URL {
        
        guard var urlComponents = URLComponents(string: urlString) else {
            throw URLEncodeingError.URLStringNotURLConvertable
        }
        
        guard let param = parameters else {
            if urlComponents.queryItems == nil {
                urlComponents.queryItems = Array<URLQueryItem>()
            }
            return urlComponents.url! }
        
        let items = param.map{
            URLQueryItem(name: String(describing: $0), value: String(describing: $1))
        }
        if urlComponents.queryItems == nil {
            urlComponents.queryItems = Array<URLQueryItem>()
        }
        
        urlComponents.queryItems?.append(contentsOf: items)
        
        return urlComponents.url!
    }
    
    
}
