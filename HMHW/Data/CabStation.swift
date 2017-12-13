//
//  CabStation
//  HMHW
//
//  Created by Perry on 13/12/2017.
//  Copyright © 2017 perrchick. All rights reserved.
//

import Foundation

class CabStation {
    let companyName: String
    let companyLogoUrl: String // Now used as image name, but originally prefered to use as image URL and use an image cache manager.

    init(companyName: String, companyLogoUrl: String) {
        self.companyName = companyName
        self.companyLogoUrl = companyLogoUrl
    }
}
