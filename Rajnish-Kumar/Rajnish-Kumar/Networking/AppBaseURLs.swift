//
// AppBaseURLs.swift
//  Rajnish-Kumar
//
//  Created by Rajnish Kumar on 18/05/19.
//  Copyright © 2019 Rajnish Kumar. All rights reserved.
//

import Foundation

struct AppBaseURLs {
        
    static let contentListUrl: String = {
        switch AppConfig.environment {
        case .production:
            return "https://rss.itunes.apple.com"
        case .development:
            return "https://rss.itunes.apple.com"
        }    }()
    
    static let contentDetailsUrl: String = {
        switch AppConfig.environment {
        case .production:
            return "https://amp-api.music.apple.com"
        case .development:
            return "https://amp-api.music.apple.com"
        }    }()

    static let contentApiVersion: String = {
        switch AppConfig.environment {
        case .production:
            return "v1"
        case .development:
            return "vi"
        }    }()
    
}
