//
//  ListInfo.swift
//  Ellis
//
//  Created by Ellis on 23/02/18.
//  Copyright © 2018 Ellis. All rights reserved.
//

import UIKit
import SwiftyJSON

class ListInfo: NSObject {

    lazy var title = ""
    lazy var image = ""
    lazy var address = ""
    lazy var detail = ""
    lazy var lat: Double = 0.00
    lazy var long: Double = 0.00
    
    override init() {
     super.init()
    }
    
    init(result: Any) {
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
        if let val = responseResult["description"].string {
            detail = val
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
    
    override init() {
        super.init()
    }
    
    init(results: Array<Any>) {
        super.init()
        for info in results {
            let listInfo = ListInfo(result: info)
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
