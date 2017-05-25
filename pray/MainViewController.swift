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

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var fajrTime: UILabel!
    
    @IBOutlet weak var sunriseTime: UILabel!
    
    @IBOutlet weak var dhuhrTime: UILabel!
    
    @IBOutlet weak var asrTime: UILabel!
    
    @IBOutlet weak var maghribTime: UILabel!
    
    @IBOutlet weak var ishaTime: UILabel!
    
    @IBOutlet weak var imsakTime: UILabel!
    
    let locationManager = CLLocationManager()
    
    var todayTimings = [String: String]()
    
   
    
    var calendar: [[String: AnyObject]]? = nil {
        didSet {
            let today = calendar![0] as [String: AnyObject]
            let todayTimingsDictionary = today["timings"] as! [String: String]
            Timing.today = todayTimingsDictionary
        }
    }
    
    
    func setTimings(timings: [String: String]) {
        fajrTime.text = timings["Fajr"]
        sunriseTime.text = timings["Sunrise"]
        dhuhrTime.text = timings["Dhuhr"]
        asrTime.text = timings["Asr"]
        maghribTime.text = timings["Maghrib"]
        ishaTime.text = timings["Isha"]
        imsakTime.text = timings["imsak"]
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            Location.getUserCurrentLocation(locationManager: locationManager)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        // Get location
        // Collect data
        // Bug if not allowed
        
        if let today = calendar?[0] {
            print(today["timings"]!)
        }
        
        
        
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        
    
}

