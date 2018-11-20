//
//  YelpLocate.swift
//  YelpLocate
//
//  Created by Vahagn Nurijanyan on 2018-11-20.
//  Copyright © 2018 BABELONi INC. All rights reserved.
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

class YelpLocate {
    static let shared = YelpLocate()
    var businesses: [Item] = [] {
        didSet {
            if !businesses.isEmpty {
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.ItemsDidChangeNotification), object: nil, userInfo: nil)
            }
        }
    }
    func getBusinesses(from array: [[String: Any]]) {
        businesses = array.map{Item($0)}
    }
    var itemsAreFromServer = false
    private init() {}
}
