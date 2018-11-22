//
//  Item.swift
//  YelpLocate
//
//  Created by Vahagn Nurijanyan on 2016-10-27.
//  Copyright © 2016 BABELONi INC. All rights reserved.
//

import MapKit

class Item: NSObject {
    private var dictionary: [String: Any]
    lazy var distance: Double = {return self.location.distance(from: UserLocationManager.instance.location)}()
    var name: String {
        get {
            return dictionary["name"] as! String
        }
    }
    var shortAddress: String {
        if let location = self.dictionary["location"] as? [String: Any] {
            if let address = location["address1"] as? String {
                return (address)
            }
        }
        return ""
    }
    var displayAddress: String {
        if let location = self.dictionary["location"] as? [String: Any] {
            if let address = location["display_address"] as? Array<String> {
                return address.joined(separator: ", ")
            }
        }
        return ""
    }
    var imageURL: URL? {
        if let image = self.dictionary["image_url"] as? String {
            return URL(string: image)
        }
        return nil
    }
    private var location: CLLocation {
        return CLLocation(latitude: latitude!, longitude: longitude!)
    }
    private var latitude: Double? {
        if let coordinate = self.dictionary["coordinates"] as? [String: Any] {
            return (coordinate["latitude"] as! Double)
        }
        return nil
    }
    private var longitude: Double? {
        if let coordinate = self.dictionary["coordinates"] as? [String: Any] {
            return (coordinate["longitude"] as! Double)
        }
        return nil
    }
    private var displayCategories: String {
        if let categories = self.dictionary["categories"] as? Array<Array<String>> {
            return (categories.map({ $0[0] }).joined(separator: ", "))
        }
        return ""
    }

    init(_ dictionary: [String: Any]) {
        self.dictionary = dictionary
    }
}

//MARK: - MKAnnotation
extension Item: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
    }
    var title: String? {
        return name
    }
    var subtitle: String? {
        return shortAddress
    }
}
