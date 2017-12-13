//
//  Configurations.swift
//  SomeApp
//
//  Created by Perry on 2/13/16.
//  Copyright © 2016 PerrchicK. All rights reserved.
//

import Foundation

class Configurations {
    static let shared = Configurations()
    
    struct Constants {
        static let GitHubLink: String = "https://github.com/PerrchicK/iOS-JobInterviewHW2.0"
    }
    
    struct Keys {
        static let NoNoAnimation: String                = "noAnimation" // not using inferred on purpose, to help Swift compiler
        struct Persistency {
            static let PermissionRequestCounter: String = "PermissionRequestCounter"
            static let LastCrash: String                = "last crash"
        }
    }
    
    private(set) var maximumWaitingTimeInMinutes: Int
    private(set) var cabsCount: Int
    
    init() {
        maximumWaitingTimeInMinutes = 30
        cabsCount = 50
    }
}
