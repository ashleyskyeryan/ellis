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
	var currentLocation: CLLocationCoordinate2D?

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
		self.locationManager.startMonitoringSignificantLocationChanges()
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.last {
			self.currentLocation = location.coordinate
			ListManager.instance.checkForNewNearbyItems(location: location.coordinate)
		}
	}
}
