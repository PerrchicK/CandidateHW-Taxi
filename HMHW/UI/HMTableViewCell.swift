//
//  HMTableViewCell.swift
//  HMHW
//
//  Created by Perry on 13/12/2017.
//  Copyright © 2017 perrchick. All rights reserved.
//

import UIKit

protocol IHMTableViewCell where Self: UITableViewCell {
    associatedtype T

    func configure(data: T)
    func cleanup()
}

class HMTableViewCell<U>: UITableViewCell, IHMTableViewCell {
    typealias T = U

    private(set) var data: U?

    func configure(data: U) {
        self.data = data
    }

    func cleanup() {
        data = nil
    }

    override func prepareForReuse() {
        cleanup()
    }
}
