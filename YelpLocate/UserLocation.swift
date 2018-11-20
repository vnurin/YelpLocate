//
//  UserLocation.swift
//  YelpLocate
//
//  Created by Vahagn Nurijanyan on 2016-10-27.
//  Copyright © 2016 BABELONi INC. All rights reserved.
//

import CoreLocation

class UserLocation: NSObject {
    
    class UserLocationManager: NSObject, CLLocationManagerDelegate {
        var locationManager: CLLocationManager = CLLocationManager()
        var latitude: Double?
        var longitude: Double?
        fileprivate var requested: Bool = false
        
        func requestLocation() {
            if self.requested {
                return
            }
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            requested = true
        }
    
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("error = \(error)")
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location = locations.last!
            if location.horizontalAccuracy > 0 {
                self.locationManager.stopUpdatingLocation()
                self.latitude = location.coordinate.latitude
                self.longitude = location.coordinate.longitude
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.UserLocationUpdatedNotification), object: nil)
                let time = DispatchTime.now() + Double(60 * NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time, execute: {[unowned self] in
                    self.locationManager.startUpdatingLocation()
                })
            }
        }
        class var instance: UserLocationManager {
            struct Static {
                static let instance: UserLocationManager = UserLocationManager()
            }
            return Static.instance
        }
//        static var instance = UserLocationManager()
    }
    
    var manager: UserLocationManager!
    
    override init() {
        manager = UserLocationManager.instance
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    var latitude: Double {
        get {
            return manager.latitude ?? Constants.TorontoLatitude
        }
    }
    
    var longitude: Double {
        get {
            return manager.longitude ?? Constants.TorontoLongitude
        }
    }
    
    var location: CLLocation {
        get {
            return CLLocation(latitude: self.latitude, longitude: self.longitude)
        }
    }
    
}
