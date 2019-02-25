//
//  ListInfo.swift
//  Ellis
//
//  Created by Ellis on 23/02/18.
//  Copyright © 2018 Ellis. All rights reserved.
//

import UIKit
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

	init(result: [String: Any], landingType: LandingType) {
		self.landingType = landingType

		self.title = result["title"] as? String ?? ""
		self.image = result["image"] as? String ?? ""
		self.address = result["address"] as? String ?? ""
		self.website = result["website"] as? String ?? ""
		self.detail = result["description"] as? String ?? ""
		self.attribution = result["attribution"] as? String ?? ""
		self.street_address = result["street address"] as? String ?? ""
		self.hours = result["hours"] as? String ?? ""
		self.lat = result["lat"] as? Double ?? 0
		self.long = result["long"] as? Double ?? 0
		self.contact_number = result["contact"] as? String ?? ""

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
	var imageName: String?

	var image: UIImage? {
		if let name = self.imageName { return UIImage(named: name) }
		return nil
	}

	init(landingType: LandingType) {
		self.landingType = landingType
		super.init()
	}

	static let empty = Lists(landingType: .Eat)

	init(results: [[String: Any]], landingType: LandingType) {
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

