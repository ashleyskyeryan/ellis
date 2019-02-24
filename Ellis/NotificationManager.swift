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
		//UIApplication.shared.registerForRemoteNotifications()
	}

}
