//
//  DataManager.swift
//  HereCandiddatesHW
//
//  Created by Perry on 12/12/2017.
//  Copyright © 2017 perrchick. All rights reserved.
//

import UIKit

class DataManager {
    static let shared = DataManager()

    lazy var stations: [CabStation] = {
        var stations = [CabStation]()
        stations.append(CabStation(companyName: "Gett", companyLogoUrl: "Gett"))
        stations.append(CabStation(companyName: "Perry & Co.", companyLogoUrl: "cab-stub"))
        stations.append(CabStation(companyName: "Ha Castle", companyLogoUrl: "hakastel"))
        stations.append(CabStation(companyName: "Ha Shekem", companyLogoUrl: "hashekem"))

        return stations
    }()
    var cabsList: [CabOrderInfo]
    let awakeningTime: TimeInterval
    var elapsedTime: TimeInterval {
        return Date().timeIntervalSince1970 - awakeningTime
    }

    private init() {
        awakeningTime = Date().timeIntervalSince1970
        cabsList = []
        // https://developer.apple.com/documentation/swift/array/1538966-reservecapacity
        cabsList.reserveCapacity(Configurations.shared.cabsCount)

        for i in 0..<Configurations.shared.cabsCount {
            let random = PerrFuncs.random(from: i, to: 1000)
            let cabOrderInfo = CabOrderInfo(company: stations[random % stations.count])
            cabOrderInfo.eta = TimeInterval(random)
            cabsList.append(cabOrderInfo)
        }
    }

    func getTaxi(taxiIndex: Int) -> CabOrderInfo {
        return cabsList[taxiIndex]
    }
}

// I took some insperation from the Android development, to enable a fluent interface
extension UserDefaults {
    static func save(value: Any, forKey key: String) -> UserDefaults {
        UserDefaults.standard.set(value, forKey: key)
        return UserDefaults.standard
    }
    
    static func remove(key: String) -> UserDefaults {
        UserDefaults.standard.set(nil, forKey: key)
        return UserDefaults.standard
    }
    
    static func load<T>(key: String) -> T? {
        if let actualValue = UserDefaults.standard.object(forKey: key) {
            return actualValue as? T
        }
        
        return nil
    }
    
    static func load<T>(key: String, defaultValue: T) -> T {
        if let actualValue = UserDefaults.standard.object(forKey: key) {
            return (actualValue as? T).or(defaultValue)
        }
        
        return defaultValue
    }
}
