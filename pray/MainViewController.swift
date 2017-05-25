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
        MainViewController.fetchCalendar { (data, error) in
            calendar = data!
            print(calendar!)
        }
    }
}

var calendar: [[String: AnyObject]]? = nil




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
    
    static func fetchCalendar(completion: @escaping (_ calendar: ([[String: AnyObject]])?, _ error: NSError?) -> Void) {
        
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
            
            AladhanClient.taskForGETMethod(parameters: parameters as [String : AnyObject], method: "calendar", completion: { (result, error) in

                func sendError(_ error: String) {
                    let userInfo = [NSLocalizedDescriptionKey : error]
                    completion(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                }
                
                guard (error == nil) else {
                    sendError("There was an error with your request: \(error.debugDescription)")
                    return
                }
                
                guard let data = result!["data"] as? [[String : AnyObject]] else {
                    sendError("No data was returned by the request!")
                    return
                }
                
                completion(data, nil)

            })
            
            
        }
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

