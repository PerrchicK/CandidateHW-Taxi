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
        static let GitHubLink: String = "https://github.com/PerrchicK/CandidateHW-Taxi"
    }
    
    private(set) var cabsCount: Int
    private(set) var refreshInterval: TimeInterval
    
    init() {
        cabsCount = 20
        refreshInterval = 1
    }
}
