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
    static let CellHeight: CGFloat = 50
    
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyLogoImageView: UIImageView!
    
    override func awakeFromNib() {
    }

    override func cleanup() {
        companyLogoImageView.image = nil
    }
    
    override func configure(data: CabOrderInfo) {
        // In a real project, the image will not be stored locally of course (in most cases), this is the place initiate an async image fetch operation, and do a relevance check of the image on callback.
        companyLogoImageView.image = UIImage(named: data.company.companyLogoUrl)
        companyNameLabel.text = data.company.companyName
        etaLabel.text = "\(data.eta)"
    }
}

