//
//  ListInfo.swift
//  Ellis
//
//  Created by Ellis on 23/02/18.
//  Copyright © 2018 Ellis. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit

class ListInfo: NSObject {

    lazy var title = ""
    lazy var image = ""
    lazy var address = ""
    lazy var detail = ""
	lazy var website = ""
    lazy var attribution = ""
    lazy var lat: Double = 0.00
    lazy var long: Double = 0.00
    var landingType: LandingType
	
	var annotationImage: UIImage? {
		switch self.landingType {
		case .Shop:
			return UIImage(named: "mark-shop")
		case .Eat:
			return UIImage(named: "mark-eat")
		case .Drink:
			return UIImage(named: "mark-drink")
		case .Rest:
			return UIImage(named: "mark-beautify")
		}

	}
	
	var coordinate: CLLocationCoordinate2D { return CLLocationCoordinate2D(latitude: self.lat, longitude: self.long) }
    
    init(landingType: LandingType = Globals.shared.landingType) {
        self.landingType = landingType
        super.init()
    }
    
    init(result: Any, landingType: LandingType = Globals.shared.landingType) {
        self.landingType = landingType
        super.init()
        
        let responseResult = JSON(result)
        
        if let val = responseResult["title"].string {
            title = val
        }
        if let val = responseResult["image"].string {
            image = val
        }
		if let val = responseResult["address"].string {
			address = val
		}
		if let val = responseResult["website"].string {
			website = val
		}
        if let val = responseResult["description"].string {
            detail = val
        }
        if let val = responseResult["attribution"].string {
            attribution = val
        }
        if let val = responseResult["lat"].double {
            lat = val
        }
        if let val = responseResult["long"].double {
            long = val
        }
        
    }
}

class Lists: NSObject {

    var lists: Array<ListInfo> = Array<ListInfo>()
    var searchList: Array<ListInfo> = Array<ListInfo>()
    var landingType: LandingType
    
    init(landingType: LandingType = Globals.shared.landingType) {
        self.landingType = landingType
        super.init()
    }
    
    init(results: Array<Any>, landingType: LandingType = Globals.shared.landingType) {
        self.landingType = landingType
        super.init()
        for info in results {
            let listInfo = ListInfo(result: info, landingType: landingType)
            lists.append(listInfo)
        }
        sortByTitle()
    }
    
    // For get list by title.
    func getListByTitle(_ title: String) {
        searchList.removeAll()
        for listInfo in self.lists {
            if listInfo.title.lowercased().range(of: title.lowercased()) != nil {
                searchList.append(listInfo)
            }
        }
    }
    
    // For list sort alphabetically.
    func sortByTitle() {

        let sortedArray = lists.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == ComparisonResult.orderedAscending }
        self.lists.removeAll()
        self.lists = sortedArray
        
    }
    
}
