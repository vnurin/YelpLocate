//
//  Load.swift
//  YelpLocate
//
//  Created by Vahagn Nurijanyan on 2016-10-29.
//  Copyright © 2016 BABELONi INC. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let basePath = "https://api.yelp.com/v3/"
    static let ThumbnailFrame = CGRect(x:0.0, y:0.0, width:64.0, height:64.0)
    static let ButtonTitles = ["By Name", "By Distance"]
    static let ItemsDidChangeNotification = "ItemsDidChangeNotification"
    static let UserLocationUpdatedNotification = "UserLocationUpdatedNotification"
//    static let ID = "GS-JJLsD2oA2RKT159BCjg"
    static let Key = "QLxSzhwtQAgxCff4OR41aL1lwBSiygcUc8h3VyKBhiKLAbVJLBPZpDapVy4QkZ5fpcqW-90avEzmQyZPVNSWI4dLB2e2J7Dg1-TjaFsgW2GBVq-iPx1gVKkeI0cRWHYx"
    static let TorontoLatitude = 43.700110
    static let TorontoLongitude = -79.416300
    static let TorontoCoordinates = "43.7001100,-79.4163000"
}

class Load {
    let limit: Int = 10
    var itemsAreFromServer = false
    var items: Array<Item> = [] {
        didSet {
            if !items.isEmpty {
//                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.ItemsDidChangeNotification), object: nil, userInfo: ["isFromServer": itemsAreFromServer, "items": items ])
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.ItemsDidChangeNotification), object: nil, userInfo: nil)
            }
        }
    }
    class var instance: Load {
        struct Static {
            static let instance: Load = Load()
        }
        return Static.instance
    }
//    static var instance = Load()
}
