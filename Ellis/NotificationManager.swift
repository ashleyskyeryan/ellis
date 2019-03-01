//
//  NotificationManager.swift
//  Ellis
//
//  Created by Ben Gottlieb on 2/23/19.
//  Copyright © 2019 Lomesh Pansuriya. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager {
	static let instance = NotificationManager()


	func setup() {
		self.requestAuthorization()
	}

	func requestAuthorization(){
		if #available(iOS 10.0, *) {
			UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
			}
		}
	}

	func showNearbyNotification(for items: [ListInfo]) {
		guard let desc = items.nearbyDescription else { return }
		DispatchQueue.main.async {
			if #available(iOS 10.0, *) {
				let content = UNMutableNotificationContent()
				let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
				content.title = items.nearbyTitle

				content.body = desc

				let request = UNNotificationRequest(identifier: "nearby", content: content, trigger: trigger)

				let center = UNUserNotificationCenter.current()
				center.add(request) { _ in print ("completed") }
			}
		}

	}

}

extension Array where Element == ListInfo {
	var nearbyDescription: String? {
		var message: String?

		switch self.count {
		case 0: return ""
		case 1: message = "You're right near \(self[0].title)!"
		default:
			message = "You're near \(self.count) Ellis favorites, including \(self[0].title) and \(self[1].title)!"
		}

		return message
	}

	var nearbyTitle: String {
		return self.count == 1 ? "Ellis Pick Nearby!" : "Ellis Picks Nearby!"
	}
}
