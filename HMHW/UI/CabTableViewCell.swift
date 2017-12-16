//
//  CabTableViewCell.swift
//  HMHW
//
//  Created by Perry on 13/12/2017.
//  Copyright © 2017 perrchick. All rights reserved.
//

import UIKit
protocol CabTableViewCellDelegate: class {
    func cabTableViewCellDidChangedMinute(cell: CabTableViewCell)
}

class CabTableViewCell: HMTableViewCell<CabOrderInfo> {
    static let Identifier: String = "CabTableViewCell"
    static let CellHeight: CGFloat = 80
    
    weak var delegate: CabTableViewCellDelegate?
    var elapsedSeconds: TimeInterval! {
        didSet {
            let elapsedMinutes = elapsedSeconds.toMinutes()
            let elapsedTimeTitle: String
            if elapsedMinutes > 0 {
                elapsedTimeTitle = "\(elapsedMinutes)m"
            } else {
                elapsedTimeTitle = String(format: "%.0fs", elapsedSeconds)
            }
            
            if etaLabel.text == elapsedTimeTitle { return }

            if (etaLabel.text?.count).or(0) > 0 && elapsedMinutes > 0 { // Detect changes
                self.delegate?.cabTableViewCellDidChangedMinute(cell: self)
            }
            
            etaLabel.text = elapsedTimeTitle
        }
    }

    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyLogoImageView: UIImageView!

    override func awakeFromNib() {
        etaLabel.text = nil
        companyNameLabel.text = nil
    }

    override func cleanup() {
        companyLogoImageView.image = nil
        etaLabel.text = ""

        super.cleanup()
    }

    func refreshUi() {
        guard let data = data else { return }

        self.elapsedSeconds = data.eta.elapsedSeconds
    }

    override func configure(data: CabOrderInfo) {
        cleanup()
        super.configure(data: data)

        // In a real project, the image will not be stored locally of course (in most cases), this is the place initiate an async image fetch operation, and do a relevance check of the image on callback.
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

    var elapsedSeconds: TimeInterval {
        return self - PerrFuncs.currentTimstamp
    }
}

