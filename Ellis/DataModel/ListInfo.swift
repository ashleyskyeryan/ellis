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

class ListInfo: Codable, Equatable {

    var title = ""
    var image = ""
	var address = ""
	var street_address = ""
	var contact_number = ""
	var hours = ""
    var detail = ""
	var website = ""
    var attribution = ""
    var lat: Double = 0.00
    var long: Double = 0.00
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
			
		case .Favorites: return nil
		}

	}
	
	var isFavorite: Bool { return Favorites.instance.isFavorite(self) }
	var coordinate: CLLocationCoordinate2D { return CLLocationCoordinate2D(latitude: self.lat, longitude: self.long) }
    
    init(landingType: LandingType) {
        self.landingType = landingType
    }
    
    init(result: Any, landingType: LandingType) {
        self.landingType = landingType
		
        let responseResult = JSON(result)
		
		self.title = responseResult["title"].string ?? ""
		self.image = responseResult["image"].string ?? ""
		self.address = responseResult["address"].string ?? ""
		self.website = responseResult["website"].string ?? ""
		self.detail = responseResult["description"].string ?? ""
		self.attribution = responseResult["attribution"].string ?? ""
		self.street_address = responseResult["street address"].string ?? ""
		self.hours = responseResult["hours"].string ?? ""
		self.lat = responseResult["lat"].double ?? 0
		self.long = responseResult["long"].double ?? 0
		self.contact_number = responseResult["contact"].string ?? ""
        
    }
	
	var phone: String {
		return self.contact_number.filter( { "0123456789".contains($0) })
	}
	
	static func ==(lhs: ListInfo, rhs: ListInfo) -> Bool {
		return lhs.title == rhs.title && lhs.address == rhs.address && lhs.website == rhs.website && lhs.lat == rhs.lat && lhs.long == rhs.long
	}
}

class Lists: NSObject {

    var lists: [ListInfo] = []
    var searchList: [ListInfo] = []
    var landingType: LandingType
    
    init(landingType: LandingType) {
        self.landingType = landingType
        super.init()
    }
    
    init(results: Array<Any>, landingType: LandingType) {
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
