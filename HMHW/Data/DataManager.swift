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

    private(set) var cabsList: [CabOrderInfo]
    var timer: ClosureTimer?

    lazy var backgroundQueue: DispatchQueue = DispatchQueue(label: "Timer", qos: .background, attributes: .concurrent)

    lazy var stations: [CabStation] = {
        var stations = [CabStation]()
        stations.append(CabStation(companyName: "Gett", companyLogoUrl: "Gett"))
        stations.append(CabStation(companyName: "Perry's", companyLogoUrl: "cab-stub-2"))
        stations.append(CabStation(companyName: "Perry & Co.", companyLogoUrl: "cab-stub"))
        stations.append(CabStation(companyName: "Gordon", companyLogoUrl: "gordon"))
        stations.append(CabStation(companyName: "Azrieli", companyLogoUrl: "azrieli"))
        stations.append(CabStation(companyName: "Castle", companyLogoUrl: "hakastel"))
        stations.append(CabStation(companyName: "Shekem", companyLogoUrl: "hashekem"))

        return stations
    }()

    private init() {
        cabsList = []
        // https://developer.apple.com/documentation/swift/array/1538966-reservecapacity
        cabsList.reserveCapacity(Configurations.shared.cabsCount)

        for i in 0..<Configurations.shared.cabsCount {
            let random = PerrFuncs.random(from: i, to: 1000)
            let cabOrderInfo = CabOrderInfo(company: stations[random % stations.count])
            cabOrderInfo.eta = Date(timeIntervalSinceNow: TimeInterval(random)).timeIntervalSince1970
            cabsList.append(cabOrderInfo)
        }

        cabsList.sort(by: { $0.eta < $1.eta } )

        beginEndlessUpdates()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive(notification:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(notification:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    @objc func applicationDidBecomeActive(notification: Notification) {
        beginEndlessUpdates()
    }

    @objc func applicationWillResignActive(notification: Notification) {
        timer?.cancel()
        timer = nil
    }

    func beginEndlessUpdates() {
        // Prevent duplicated calls
        guard UIApplication.shared.applicationState == .active && timer == nil else { return }

        // Mocks up an update, may arrive by: polling result, update from socket, etc.
        timer = ClosureTimer.runBlockAfterDelay(afterDelay: Configurations.shared.refreshInterval, repeats: true, userInfo: nil, onQueue: backgroundQueue) { [weak self] _ in
            guard (self?.cabsList.count).or(0) > 0 else {
                self?.timer?.cancel()
                return
            }

            self?.refreshData()
        }
    }

    func refreshData() {
        let currentTimstamp: TimeInterval = PerrFuncs.currentTimstamp
        cabsList = cabsList.filter( { $0.eta - currentTimstamp > 0 } )

        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name.DataRefreshed, object: nil)
        }
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

extension NSNotification.Name {
    static let DataRefreshed: NSNotification.Name = NSNotification.Name(rawValue: "DataRefreshed")
}
