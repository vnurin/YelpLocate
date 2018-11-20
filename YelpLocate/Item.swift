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
    private var userLocation = UserLocation()
    lazy var distance: Double = {return self.location.distance(from: self.userLocation.location)}()
    var name: String {
        get {
            return dictionary["name"] as! String
        }
    }
    var shortAddress: String {
        if let location = self.dictionary["location"] as? [String: Any] {
            if let address = location["address"] as? Array<String> {
                if let neighborhoods = location["neighborhoods"] as? Array<String> {
                    return (address + [neighborhoods[0]]).joined(separator: ", ")
                }
                return address.joined(separator: ", ")
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
    var thumbnailImageURL: URL? {
        if let image = self.dictionary["url"] as? String {
            return URL(string: image)
        }
        return nil
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
    var review: String? {
        return self.dictionary["snippet_text"] as? String
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
