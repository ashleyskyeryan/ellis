//
//  LocationManager.swift
//  Ellis
//
//  Created by Ben Gottlieb on 2/23/19.
//  Copyright © 2019 Lomesh Pansuriya. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import UserNotifications

class LocationManager: NSObject {
	static let instance = LocationManager()

	var locationManager = CLLocationManager()

	override init() {
		super.init()

		self.locationManager.delegate = self
	}

	func setup() {
		self.locationManager.requestAlwaysAuthorization()
	}
}

extension LocationManager: CLLocationManagerDelegate {
	public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		print("Authorized!")

		self.locationManager.startMonitoringSignificantLocationChanges()
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.last {
			DispatchQueue.main.async {
				if #available(iOS 10.0, *) {
					let content = UNMutableNotificationContent()
					let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
					content.title = "Location Updated"

					content.body = location.description

					let request = UNNotificationRequest(identifier: "\(location)", content: content, trigger: trigger)

					let center = UNUserNotificationCenter.current()
					center.add(request) { _ in print ("completed") }
				}
			}
		}
	}
}
