//
//  Favorites.swift
//  Ellis
//
//  Created by Ben Gottlieb on 2/10/19.
//  Copyright © 2019 Lomesh Pansuriya. All rights reserved.
//

import Foundation

class Favorites {
	static let instance = Favorites()
	var favorites: [ListInfo] = []
	let storedFavoritesKey = "stored-favorites"
	
	init() {
		self.lists = Lists(results: [], landingType: .Favorites)
		if let data = UserDefaults.standard.data(forKey: self.storedFavoritesKey), let faves = try? JSONDecoder().decode([ListInfo].self, from: data) {
			self.favorites = faves
			self.lists.lists = self.favorites
		}
	}
	
	func isFavorite(_ item: ListInfo) -> Bool {
		return self.favorites.contains(item)
	}
	
	var lists: Lists
	
	func addFavorite(item: ListInfo) {
		self.favorites.append(item)
		self.saveFavorites()
	}
	
	func removeFavorite(item: ListInfo) {
		if let index = self.favorites.index(of: item) {
			self.favorites.remove(at: index)
		}
		self.saveFavorites()
	}
	
	func saveFavorites() {
		if let data = try? JSONEncoder().encode(self.favorites) {
			UserDefaults.standard.set(data, forKey: self.storedFavoritesKey)
		}
		self.lists.lists = self.favorites
	}
}
