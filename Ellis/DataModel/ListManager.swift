//
//  ListManager.swift
//  Ellis
//
//  Created by Ben Gottlieb on 2/25/19.
//  Copyright © 2019 Lomesh Pansuriya. All rights reserved.
//

import Foundation
import MapKit

class ListManager {
	static let instance = ListManager()
	var cachedItems: [LandingType: Lists] = [:]
	var lastNearbyList: [ListInfo] = []

	func checkForNewNearbyItems(location loc: CLLocationCoordinate2D? = nil) {
		guard let location = loc ?? LocationManager.instance.currentLocation else { return }
		let distance = 1000.0			// this is the number of meters to a 'nearby' location

		let nearby = self.items(near: location, range: distance)
		if nearby != self.lastNearbyList {
			self.lastNearbyList = nearby

			if nearby.count > 0 {
				NotificationManager.instance.showNearbyNotification(for: nearby)
			}
		}
	}


	func items(near: CLLocationCoordinate2D, range: CLLocationDistance = 1.0) -> [ListInfo] {
		var results: [ListInfo] = []

		for type in LandingType.allCases {
			let list = self.fetchItems(for: type)
			for item in list.lists {
				if item.isNear(near, range: range), !results.contains(item) { results.append(item) }
			}
		}

		return results
	}

	func fetchItems(for type: LandingType) -> Lists {
		if let cached = self.cachedItems[type] { return cached }

		let stringLandingType = type.rawValue
		guard let path = Bundle.main.path(forResource: stringLandingType, ofType: "json") else { return Lists.empty }

		do {
			let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

			guard let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return Lists.empty }

			if let dataList = jsonResult["list"] as? [[String: Any]] {
				self.cachedItems[type] = Lists(results: dataList, landingType: Globals.shared.landingType)
				self.cachedItems[type]?.imageName = jsonResult["image"] as? String
			}
		} catch {

		}

		return self.cachedItems[type] ?? Lists.empty
	}
}
