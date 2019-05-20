//
//  AppConfig.swift
//  Rajnish-Kumar
//
//  Created by Rajnish Kumar on 18/05/19.
//  Copyright © 2019 Rajnish Kumar. All rights reserved.
//


import Foundation
import UIKit


enum DevelopmentEnvironment {
    case development
    case production
}

struct AppConfig {
    
    static let environment: DevelopmentEnvironment = .production
     static let isDebugLogEnable: Bool = true

}

