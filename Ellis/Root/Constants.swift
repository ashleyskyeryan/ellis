//
//  Constants.swift
//  Ellis
//
//  Created by Ellis on 23/02/18.
//  Copyright © 2018 Ellis. All rights reserved.
//

import UIKit

// MARK: -Enumerations.

enum LandingType {
    case Shop, Eat, Drink, Beautify
}

enum MapType {
    case Single, Multiple
}

class Constants: NSObject {

    // Table Cell Identifier.
    struct CellIdentifier {
        let landingPage: String = "segueToLandingViewController"
        let mapPage: String = "SegueToMapViewController"
        let detailPage: String = "segueToDetailViewController"
    }
    
    // GoogleMap Key.
    let googleMapApiKey = "AIzaSyBbvEcI63Y_RsrKyaz4bUYE3yoI_jL_feg"
}
