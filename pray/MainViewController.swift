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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        let loadingFrame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        let loadingView = UIView(frame: loadingFrame)
        loadingView.backgroundColor = UIColor.white
        view.addSubview(loadingView)
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = loadingView.center
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.startAnimating()
        loadingView.addSubview(activityIndicator)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        Location.getUserCurrentLocation(locationManager: locationManager) { (location) in
            if location != nil {
                
                Location.getGeoCoder(location!, completion: { (timeZone) in
                    Location.currentTimeZone = timeZone
                    
                    Timing.fetchCalendar(location: location!, completion: { (calendar, error) in
                        let today = calendar![0] as [String: AnyObject]
                        let todayTimingsDictionary = today["timings"] as! [String: AnyObject]
                        print(todayTimingsDictionary)
                        Timing.today = Timing.DailyTiming.init(dictionary: todayTimingsDictionary)
                        DispatchQueue.main.async {
                            self.showTiming(timing: Timing.today!)
                            loadingView.removeFromSuperview()
                        }
                    })
                })
            }
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            Location.getUserCurrentLocation(locationManager: locationManager, completion: { (location) in
                print(location!)
            })
        }
    }
    
    func showTiming(withDictionary timing: [String: String]) {
        fajrTime.text = timing["Fajr"]
        sunriseTime.text = timing["Sunrise"]
        dhuhrTime.text = timing["Dhuhr"]
        asrTime.text = timing["Asr"]
        maghribTime.text = timing["Maghrib"]
        ishaTime.text = timing["Isha"]
        imsakTime.text = timing["imsak"]
    }
    
    func showTiming(timing: Timing.DailyTiming) {
        fajrTime.text = timing.Fajr
        sunriseTime.text = timing.Sunrise
        dhuhrTime.text = timing.Asr
        asrTime.text = timing.Asr
        maghribTime.text = timing.Maghrib
        ishaTime.text = timing.Isha
        imsakTime.text = timing.Imsak
    }
}

