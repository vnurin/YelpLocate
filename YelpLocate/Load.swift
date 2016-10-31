//
//  Load.swift
//  YelpLocate
//
//  Created by Vahagn Nurijanyan on 2016-10-29.
//  Copyright © 2016 BABELONi INC. All rights reserved.
//

import Foundation

struct Constants {
    static let ThumbnailFrame = CGRect(x:0.0, y:0.0, width:64.0, height:64.0)
    static let ButtonTitles = ["By Name", "By Distance"]
    static let ItemsCameNotification = "ItemsCameNotification"
    static let UserLocationUpdatedNotification = "UserLocationUpdatedNotification"
    static let YelpConsumerKey = "xNm8gMavmp6i3LlnzJPf_w"
    static let YelpConsumerSecret = "7uh4fYdz9r6IX5qYQqzvI2GQsKA"
    static let YelpToken = "wkJD2bLk3gzHmREVjQ8MLlFX3OgQOnmz"
    static let YelpTokenSecret = "kp83Nt2APdBL_NezCeR-s6bdrP0"
    static let TorontoLatitude = 43.700110
    static let TorontoLongitude = -79.416300
    static let TorontoCoordinates = "43.7001100,-79.4163000"
}

class Load {
    let limit: Int = 10
    lazy var client: Client! = Client(consumerKey: Constants.YelpConsumerKey, consumerSecret: Constants.YelpConsumerSecret, accessToken: Constants.YelpToken, accessSecret: Constants.YelpTokenSecret)
    var itemsAreFromServer = false
    var items: Array<Item> = [] {
        didSet {
            if !items.isEmpty {
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.ItemsCameNotification), object: nil, userInfo: ["isFromServer": itemsAreFromServer, "items": items ])
            }
        }
    }
    class var instance: Load {
        struct Static {
            static let instance: Load = Load()
        }
        return Static.instance
    }
}
