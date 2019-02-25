//
//  ListManager.swift
//  Ellis
//
//  Created by Ben Gottlieb on 2/25/19.
//  Copyright © 2019 Lomesh Pansuriya. All rights reserved.
//

import Foundation

class ListManager {
	static let instance = ListManager()
	var cachedItems: [LandingType: Lists] = [:]

	func fetchItems(for type: LandingType) -> Lists {
		if let cached = self.cachedItems[type] { return cached }

		let stringLandingType = Globals.shared.landingType.rawValue
		let path = Bundle.main.path(forResource: stringLandingType, ofType: "json")!

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
