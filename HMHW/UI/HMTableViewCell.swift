//
//  HMTableViewCell.swift
//  HMHW
//
//  Created by Perry on 13/12/2017.
//  Copyright © 2017 perrchick. All rights reserved.
//

import UIKit

extension IHMTableViewCell {
    func prepareForReuse() {
        cleanup()
    }
}

protocol IHMTableViewCell where Self: UITableViewCell {
    associatedtype T

    func configure(data: T)
    func cleanup()
}

class HMTableViewCell<U>: UITableViewCell, IHMTableViewCell {
    typealias T = U

    func configure(data: U) {
        fatalError("should be implemented by children")
    }

    func cleanup() {
        fatalError("should be implemented by children")
    }

    override func prepareForReuse() {
        cleanup()
    }
}
