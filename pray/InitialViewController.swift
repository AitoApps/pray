//
//  InitialViewController.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/21/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import UserNotifications

class InitialViewController: UIViewController, UNUserNotificationCenterDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var welcomeStackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backgroundPatternImageView: UIImageView!
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var allowLocationAccessButton: UIButton!
    @IBOutlet weak var allowNotificationAccessButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundPatternImageView.imageGradientFadeTop(target: self)
        
        allowLocationAccessButton.layer.cornerRadius = 20
        allowLocationAccessButton.layer.borderWidth = 1.0
        allowLocationAccessButton.layer.borderColor = UIColor.white.cgColor
        
        
        allowNotificationAccessButton.layer.cornerRadius = 20
        allowNotificationAccessButton.layer.borderWidth = 1.0
        allowNotificationAccessButton.layer.borderColor = UIColor.white.cgColor
        
        UNUserNotificationCenter.current().delegate = self
        
        allowNotificationAccessButton.isHidden = true
        
        allowLocationAccessButton.addTarget(self, action: #selector(getLocation), for: .touchUpInside)
        allowNotificationAccessButton.addTarget(self, action: #selector(setupUserNotification), for: .touchUpInside)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        welcomeStackView.isHidden = true
        
        activityIndicator.startAnimating()
        
        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            
            if hasPlacemark() {
                
                allowLocationAccessButton.removeFromSuperview()
                allowNotificationAccessButton.removeFromSuperview()
                
                isInRange(completion: { (inRange: Bool) in
                    if inRange {
                        self.preloadDaysFromCoreData()
                        if DataSource.calendar.count == 0 {
                            self.getCalendarFromAPIToCoreData(placemark: DataSource.currentPlacemark, completion: {
                                self.createNotificationFromCalendar {
                                    self.presentMain()
                                }
                            })
                        } else {
                            self.presentMain()
                        }
                    } else {
                        self.updateLocation()
                    }
                })
            }
            
        } else {
            activityIndicator.stopAnimating()
            
            welcomeStackView.isHidden = false

        }
        
    }
    
    func createNotificationFromCalendar(completion: @escaping () -> Void) {
        
        for day in DataSource.calendar {
            let now = Date()
            
            let timings = self.preloadTimingsFromCoreData(for: day)
            
            for timing in timings {
                if timing.date!
                    as Date > now {
                    let timeInterval = timing.date!.timeIntervalSinceNow
                    self.createNotification(with: timeInterval, timingName: timing.name!, readableDate: timing.readableDate! + " " + timing.day!.readableDate!)
                }
            }
        }
        
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (notificationRequests: [UNNotificationRequest]) in
            completion()
        })
        
    }
    
    func checkCurrentLocation() -> CLLocation {
        if let location = locationManager.location {
            return location
        } else {
            return checkCurrentLocation()
        }
    }
    
    func updateLocation() {
        getPlacemark {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            self.setupUserNotification()
        }
    }
    
    func getLocation() {
        
        allowLocationAccessButton.setTitle("", for: UIControlState.normal)
        allowLocationAccessButton.isEnabled = false
        allowLocationAccessButton.activityIndicator(show: true)
        
        getPlacemark {
            self.executeOnMain {
                self.allowLocationAccessButton.activityIndicator(show: false)
//                let placemark = DataSource.currentPlacemark
//                let lines = placemark?.addressDictionary?["FormattedAddressLines"] as! NSArray
//                let cityName = placemark?.locality ?? DataSource.currentPlacemark.subAdministrativeArea
//                let line = lines[0] as! String
//                let cityNameLabel = cityName ?? line

                self.allowLocationAccessButton.removeFromSuperview()
                self.allowNotificationAccessButton.isHidden = false
            }
        }
    }
    
    func getPlacemark(completion: @escaping () -> Void) {
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
            executeOnMain(withDelay: 1.0, { 
                let location = self.checkCurrentLocation()
                
                self.locationManager.stopUpdatingLocation()
                
                CLGeocoder().reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: Error?) in
                    guard error == nil else {
                        return
                    }
                    
                    let placemark = placemarks![0]
                    
                    let encodedData = NSKeyedArchiver.archivedData(withRootObject: placemark)
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(encodedData, forKey: "placemark")
                    
                    DataSource.currentPlacemark = placemark
                    
                    self.getCalendarFromAPIToCoreData(placemark: placemark) {
                        completion()
                    }
                }

            })
        }
    }
    
    func hasPlacemark() -> Bool {
        if (UserDefaults.standard.object(forKey: "placemark") as? Data) != nil {
            return true
        } else {
            return false
        }
    }
    
    func isDegreesInRange(x: CLLocationDegrees, in degrees: CLLocationDegrees) -> Bool {
        let lowerBound = (x) - 0.1
        let upperBound = (x) + 0.1
        
        if lowerBound...upperBound ~= degrees {
            return true
        }
        
        return false
    }
    
    func isInRange(completion: @escaping (Bool) -> Void) {
        
        guard let placemarkData = UserDefaults.standard.object(forKey: "placemark") as? Data else {
            completion(false)
            return
        }
        
        let placemark = NSKeyedUnarchiver.unarchiveObject(with: placemarkData) as! CLPlacemark
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            executeOnMain(withDelay: 1.0, { 
                let location = self.checkCurrentLocation()
                
                self.locationManager.stopUpdatingLocation()
                
                let previousLocation = placemark.location
                
                
                let latitudeIsInRange = self.isDegreesInRange(x: location.coordinate.latitude, in: (previousLocation?.coordinate.latitude)!)
                
                
                let longitudeIsInRange = self.isDegreesInRange(x: location.coordinate.longitude, in: (previousLocation?.coordinate.longitude)!)
                
                if  latitudeIsInRange && longitudeIsInRange  {
                    DataSource.currentPlacemark = placemark
                    completion(true)
                }
                
                completion(false)
            })
            
        }
    }
    
    func presentMain() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let main = storyboard.instantiateViewController(withIdentifier: "Main") as! UINavigationController
        self.present(main, animated: false, completion: nil)
    }
    
    
    func setupUserNotification() {
        self.activityIndicator.startAnimating()
        
        if allowNotificationAccessButton != nil {
            self.allowNotificationAccessButton.isHidden = true
            
        }
        
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings: UNNotificationSettings) in
            if notificationSettings.authorizationStatus != .authorized {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (didAllow: Bool, error: Error?) in
                    if didAllow {
                        
                        
                        
                        self.createNotificationFromCalendar {
                            self.activityIndicator.stopAnimating()
                            self.presentMain()
                        }
                    } else {
                        self.activityIndicator.stopAnimating()
                        let alert = UIAlertController(title: "Notification Access", message: "For better experience, you can turn on your alerts in Settings", preferredStyle: .alert)

                        let action = UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                            self.presentMain()
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } else {
                self.createNotificationFromCalendar {
                    self.activityIndicator.stopAnimating()
                    self.presentMain()
                }
            }
        }
    }
    
    // Mark: Notification
    func createNotification(with timeInterval: Double, timingName: String, readableDate: String) {
        let remindIn15Mins = UNNotificationAction(identifier: "remindIn15Mins", title: "Remind me in 15 minutes", options: .destructive)
        let done = UNNotificationAction(identifier: "done", title: "Done", options: .foreground)
        let category = UNNotificationCategory(identifier: "default", actions: [remindIn15Mins, done], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        let content = UNMutableNotificationContent()
        content.title = "Pray"
        content.body = "Time for \(timingName)"
        content.categoryIdentifier = "default"
        content.sound = UNNotificationSound.default()
        content.badge = 0
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: timingName + " " + readableDate, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            
            guard error == nil else {
                let alert = UIAlertController(title: "Error", message: "Please turn your notification service in settings", preferredStyle: .alert)
                let action = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "remindIn15Mins" {
            print("Remind in 15 mins")
        } else if response.actionIdentifier == "remindIn30Mins" {
            print("Remind In 30 mins")
        } else if response.actionIdentifier == "done" {
            print("Done")
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        completionHandler()
    }
    
}


