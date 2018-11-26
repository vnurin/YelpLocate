//
//  YelpLocate.swift
//  YelpLocate
//
//  Created by Vahagn Nurijanyan on 2018-11-20.
//  Copyright © 2018 BABELONi INC. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct Constants {
    static let basePath = "https://api.yelp.com/v3/"
    static let ThumbnailFrame = CGRect(x:0.0, y:0.0, width:64.0, height:64.0)
    static let ItemsDidChangeNotification = Notification.Name(rawValue: "ItemsDidChangeNotification")
    static let UserLocationUpdatedNotification = Notification.Name(rawValue: "UserLocationUpdatedNotification")
    static let Key = "QLxSzhwtQAgxCff4OR41aL1lwBSiygcUc8h3VyKBhiKLAbVJLBPZpDapVy4QkZ5fpcqW-90avEzmQyZPVNSWI4dLB2e2J7Dg1-TjaFsgW2GBVq-iPx1gVKkeI0cRWHYx"
//    static let TorontoLatitude = 43.700110
//    static let TorontoLongitude = -79.416300
//    static let TorontoCoordinates = "43.7001100,-79.4163000"
    static let NewLatitude = 40.730610
    static let NewLongitude = -73.935242
}

enum Sorted {
    static prefix func ! (hs: Sorted) -> Sorted {
        if hs == .byDistance {
            return .byName
        }
        else {
            return .byDistance
        }
    }
    
    case byDistance, byName
    var caption: String {
        if self == .byDistance {
            return "By Distance"
        }
        else {
            return "By Name"
        }
    }
}

class YelpLocate {
    static let shared = YelpLocate()
    var businesses: [Item] = [] {
        didSet {
            if !businesses.isEmpty {
                NotificationCenter.default.post(name: Constants.ItemsDidChangeNotification, object: nil, userInfo: nil)
            }
        }
    }
    var itemsAreFromServer = false
    var sortedState = Sorted.byDistance
    func getBusinesses(from array: [[String: Any]]) {
        businesses = array.map{Item($0)}
    }
    func sortItems() {
        if businesses.isEmpty {
            return
        }
        if !itemsAreFromServer {
            sortedState = !sortedState
        }
        if sortedState == .byDistance {
            businesses.sort{ $0.distance < $1.distance }
            
        } else {
            businesses.sort{ $0.name < $1.name }
        }
    }
    
    private init() {}
}
