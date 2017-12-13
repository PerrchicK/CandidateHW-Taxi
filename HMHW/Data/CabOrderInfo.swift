//
//  CabOrderInfo.swift
//  HMHW
//
//  Created by Perry on 13/12/2017.
//  Copyright © 2017 perrchick. All rights reserved.
//

import Foundation

class CabOrderInfo {
    static let UnknownETA: TimeInterval = -1

    let company: CabStation

    private var _eta: TimeInterval?
    /// The ETA timestamp, in seconds(!). When working with external "players" in the product, consider using a Int64 for timestamp in milliseconds
    var eta: TimeInterval {
        get {
            return _eta ?? CabOrderInfo.UnknownETA
        }
        set {
            _eta = newValue
        }
    }

    init(company: CabStation) {
        self.company = company
    }
}
