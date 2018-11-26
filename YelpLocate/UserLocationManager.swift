//
//  UserLocationManager.swift
//  YelpLocate
//
//  Created by Vahagn Nurijanyan on 2016-10-27.
//  Copyright © 2016 BABELONi INC. All rights reserved.
//

import CoreLocation

    class UserLocationManager: CLLocationManager, CLLocationManagerDelegate {
        static let instance = UserLocationManager()
        
        override init() {
            super.init()
            requestWhenInUseAuthorization()
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                delegate = self
                desiredAccuracy = kCLLocationAccuracyKilometer
                requestLocation()
            }
        }
        var latitude: Double = Constants.NewLatitude
        var longitude: Double = Constants.NewLongitude
        override var location: CLLocation! {
            return CLLocation(latitude: latitude, longitude: longitude)
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location = locations.last!
            if location.horizontalAccuracy > 0 {
                stopUpdatingLocation()
                self.latitude = location.coordinate.latitude
                self.longitude = location.coordinate.longitude
                NotificationCenter.default.post(name: Constants.UserLocationUpdatedNotification, object: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(600), execute: {[weak self] in
                    self?.startUpdatingLocation()
                })
            }
            
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("error = \(error)")
        }
    }

