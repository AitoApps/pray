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
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        displayPrayTiming()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if Location.currentLocation == nil {
            if status == CLAuthorizationStatus.authorizedWhenInUse {
                Location.getUserCurrentLocation(locationManager: locationManager, completion: { (location) in
                })
            }
        }
    }
    
    func displayPrayTiming() {
        
//        let screenWidth = UIScreen.main.bounds.size.width
//        let screenHeight = UIScreen.main.bounds.size.height
//        
//        let loadingFrame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
//        let loadingView = UIView(frame: loadingFrame)
//        loadingView.backgroundColor = UIColor.white
//        view.addSubview(loadingView)
//        
//        let activityIndicator = UIActivityIndicatorView()
//        activityIndicator.center = loadingView.center
//        activityIndicator.activityIndicatorViewStyle = .gray
//        activityIndicator.startAnimating()
//        loadingView.addSubview(activityIndicator)
        
        
        Location.getUserCurrentLocation(locationManager: locationManager) { (location) in
            if location != nil {
                
                Location.getGeoCoder(location!, completion: { (timeZone) in
                    Location.currentTimeZone = timeZone
                    
                    Timing.fetchCalendar(location: location!, completion: { (calendar, error) in
                        
                        guard error == nil else {
                            print(error.debugDescription)
                            return
                        }
                        
                        print(Timing.today ?? "no timing for today")
                        
                        if Timing.today == nil {
                            
                            let date = Date()
                            
                            let dateIndexFormatter = DateFormatter()
                            dateIndexFormatter.dateFormat = "dd"
                            let todayIndex = dateIndexFormatter.string(from: date)
                            print(todayIndex)
                            
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd MMM yyyy"
                            let todayDate = dateFormatter.string(from: date)
                            print(todayDate)
                            
                            
                            
                            let index = Int(todayIndex)! - 1
                            let today = calendar![index] as [String: AnyObject]
                            let todayTimingsDictionary = today["timings"] as! [String: AnyObject]
                            print(todayDate)
                            Timing.today = Timing.DailyTiming.init(dictionary: todayTimingsDictionary, stringDate: todayDate)
                            self.showTiming(timing: Timing.today!)
                        }
                    })
                })
            }
        }
    }
    
    func showTiming(timing: Timing.DailyTiming) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        
        DispatchQueue.main.async {
            self.fajrTime.text = dateFormatter.string(from: timing.FajrTime)
            self.sunriseTime.text = dateFormatter.string(from: timing.SunriseTime)
            self.dhuhrTime.text = dateFormatter.string(from: timing.DhuhrTime)
            self.asrTime.text = dateFormatter.string(from: timing.AsrTime)
            self.maghribTime.text = dateFormatter.string(from: timing.MaghribTime)
            self.ishaTime.text = dateFormatter.string(from: timing.IshaTime)
            self.imsakTime.text = dateFormatter.string(from: timing.ImsakTime)
        }
        
        
        
        
    }
}

