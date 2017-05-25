//
//  Location.swift
//  pray
//
//  Created by Zulwiyoza Putra on 5/25/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class Location: NSObject {
    
    static var currentLocation: CLLocation? = nil {
        didSet {
            Location.getGeoCoder(currentLocation!)
        }
    }
    
    static var currentTimeZone: String? = nil {
        didSet {
            Timing.fetchCalendar(location: Location.currentLocation!) { (data, error) in
                Timing.calendar = data!
            }
        }
    }
    
    static func getAuthorizationForLocation(completion: @escaping (_ success: Bool) -> Void) {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    static func getUserCurrentLocation(locationManager: CLLocationManager) {
        getAuthorizationForLocation { (success) in
            if success {
                if let location = locationManager.location {
                    Location.currentLocation = location
                }
                
            } else {
                print("User doesn't authorized the location access")
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    static func getGeoCoder( _ location: CLLocation) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemark, error) in
            guard error == nil else {
                print("ERROR: ", error.debugDescription)
                return
            }
            
            guard let placemarks = placemark else{
                return
            }
            
            if let timeZone = placemarks[0].timeZone {
                print(timeZone.identifier)
                self.currentTimeZone = timeZone.identifier
            }
        }
    }
    
    
    
    func fetchTimeZonesDatabase() -> [[String: AnyObject]]? {
        
        if let timeZonesURL = Bundle.main.url(forResource: "timezones", withExtension: "json") {
            let rawTimeZones = try! Data(contentsOf: timeZonesURL)
            var timeZones = [[String: AnyObject]]()
            do {
                timeZones = try JSONSerialization.jsonObject(with: rawTimeZones, options: JSONSerialization.ReadingOptions()) as! [[String: AnyObject]]
                return timeZones
            } catch {
                print(error.localizedDescription)
                return nil
            }
        } else {
            return nil
        }
        
        
    }

}
