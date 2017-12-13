//
//  CabTableViewCell.swift
//  HMHW
//
//  Created by Perry on 13/12/2017.
//  Copyright © 2017 perrchick. All rights reserved.
//

import UIKit

class CabTableViewCell: HMTableViewCell<CabOrderInfo> {
    static let Identifier: String = "CabTableViewCell"
    static let CellHeight: CGFloat = 80
    
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyLogoImageView: UIImageView!

    private weak var data: CabOrderInfo?
    override func awakeFromNib() {
        etaLabel.text = nil
        companyNameLabel.text = nil
    }

    override func cleanup() {
        companyLogoImageView.image = nil
        data = nil
    }

    func refreshUi() {
        guard let data = data else { return }

        let elapsedSeconds = data.eta - PerrFuncs.currentTimstamp
        let elapsedMinutes = elapsedSeconds.toMinutes()
        let elapsedTimeTitle: String
        if elapsedMinutes > 0 {
            elapsedTimeTitle = "\(elapsedMinutes)m"
        } else {
            elapsedTimeTitle = String(format: "%.0fs", elapsedSeconds)
        }

        if etaLabel.text == elapsedTimeTitle { return }

        etaLabel.text = elapsedTimeTitle
//        etaLabel.animateFade(fadeIn: false, duration: 0.4) { [weak self] _ in
//            self?.etaLabel.text = elapsedTimeTitle
//            self?.etaLabel.animateFade(fadeIn: true, duration: 0.4)
//        }
    }

    override func configure(data: CabOrderInfo) {
        // In a real project, the image will not be stored locally of course (in most cases), this is the place initiate an async image fetch operation, and do a relevance check of the image on callback.
        self.data = data
        companyLogoImageView.image = UIImage(named: data.company.companyLogoUrl)
        companyNameLabel.text = data.company.companyName
        refreshUi()
    }
}

extension TimeInterval {
    func toTimeString(format: String) -> String {
        let formattter = DateFormatter()
        formattter.dateFormat = format//"yyyy-MM-dd HH:mm:ss:SSS"
        return formattter.string(from: Date(timeIntervalSince1970: self))
    }

    func toMinutes() -> Int {
        return Int(self) / 60
    }
}

