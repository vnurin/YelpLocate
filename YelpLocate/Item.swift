//
//  Item.swift
//  YelpLocate
//
//  Created by Vahagn Nurijanyan on 2016-10-27.
//  Copyright © 2016 BABELONi INC. All rights reserved.
//

import MapKit
import CoreLocation

class Item: NSObject, MKAnnotation {
    var dictionary: NSDictionary
    var userLocation: UserLocation = UserLocation()
    lazy var distance: Double = {return self.location.distance(from: self.userLocation.location)}()
    var name: String {
        get {
            return dictionary["name"] as! String
        }
    }
    var shortAddress: String {
        if let location = self.dictionary["location"] as? NSDictionary {
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
        if let location = self.dictionary["location"] as? NSDictionary {
            if let address = location["display_address"] as? Array<String> {
                return address.joined(separator: ", ")
            }
        }
        return ""
    }
    var thumbnailImageURL: URL? {
        if let image = self.dictionary["snippet_image_url"] as? String {
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
    var location: CLLocation {
        return CLLocation(latitude: self.latitude!, longitude: self.longitude!)
    }
    var latitude: Double? {
        if let location = self.dictionary["location"] as? NSDictionary {
            if let coordinate = location["coordinate"] as? NSDictionary {
                return (coordinate["latitude"] as! Double)
            }
        }
        return nil
    }
    var longitude: Double? {
        if let location = self.dictionary["location"] as? NSDictionary {
            if let coordinate = location["coordinate"] as? NSDictionary {
                return (coordinate["longitude"] as! Double)
            }
        }
        return nil
    }
    var displayCategories: String {
        if let categories = self.dictionary["categories"] as? Array<Array<String>> {
            return (categories.map({ $0[0] }).joined(separator: ", "))
        }
        return ""
    }
    var review: String? {
        return self.dictionary["snippet_text"] as? String
    }
/*    let categories: String?
    let reviewCount: NSNumber?
    let distance: String?*/

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
/*
        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categories = categoryNames.joined(separator: ", ")
        } else {
            categories = nil
        }
         reviewCount = dictionary["review_count"] as? NSNumber
         let distanceMeters = dictionary["distance"] as? NSNumber
         if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
         } else {
            distance = nil
         }
         let ratingImageURLString = dictionary["rating_img_url_large"] as? String
         if ratingImageURLString != nil {
            ratingImageURL = URL(string: ratingImageURLString!)
         } else {
            ratingImageURL = nil
         }
*/
    }
    class func searchWithTerm(term: String, completion: @escaping ([Item]?, Error?) -> Void) {
        _ = Client.sharedInstance.searchWithTerm(term, completion: completion)
    }
    class func searchWithTerm(term: String, sort: SortMode?, categories: [String]?, deals: Bool?, completion: @escaping ([Item]?, Error?) -> Void) -> Void {
//        _ = Client.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, deals: deals, completion: completion)
        _ = Client.sharedInstance.searchWithTerm(term, sort: sort, completion: completion)
    }
    class func businesses(array: [NSDictionary]) -> [Item] {
        var businesses = [Item]()
        for dictionary in array {
            let business = Item(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }
//MARK: MKAnnotation protocol
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
