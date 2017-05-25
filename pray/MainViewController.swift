//
//  MainViewController.swift
//  pray
//
//  Created by Zulwiyoza Putra on 5/24/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

var currentlocation: CLLocation? = nil {
    didSet {
        MainViewController.getGeoCoder(currentlocation!)
    }
}

var currentTimeZone: String? = nil {
    didSet {
        MainViewController.fetchCalendar()
    }
}
var calendar: [String: Any]? = nil




class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        // Get location
        // Collect data
        // Bug if not allowed
        
        
                
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            getUserCurrentLocation()
        }
    }
    
    static func fetchTimeZonesDatabase() -> [[String: AnyObject]]? {
        
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
    
    static func fetchCalendar() {
        
        let url = URL(string: "http://api.aladhan.com/calendar?")
        
        if let location = currentlocation {
            let latitude = location.coordinate.latitude.description
            let longitude = location.coordinate.longitude.description
            
            guard let timeZone = currentTimeZone else {
                return
            }
            
            let parameters = [
                "latitude": latitude,
                "longitude": longitude,
                "timezonestring": timeZone,
                "method": "2",
                "month": "6",
                "year": "2017",
            ]
        }
        
        
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
        }
        
        task.resume()
    }
    
    func getAuthorizationForLocation(completion: @escaping (_ success: Bool) -> Void) {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func getUserCurrentLocation() {
        getAuthorizationForLocation { (success) in
            if success {
                if let location = self.locationManager.location {
                    currentlocation = location
                }
                
            } else {
                print("User doesn't authorized the location access")
                self.locationManager.requestWhenInUseAuthorization()
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
                currentTimeZone = timeZone.identifier
            }
        }
    }
}

