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

class InitialViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backgroundPatternImageView: UIImageView!
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation? = nil {
        didSet {
            activityIndicator.startAnimating()
            getPlacemark {
                self.setupUserNotification()
            }
        }
    }
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    @IBOutlet weak var welcomeStackView: UIStackView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundPatternImageView.imageGradientFadeTop(target: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialSetup()
    }
    
    func initialSetup() {
        activityIndicator.startAnimating()
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            activityIndicator.stopAnimating()
            getLocation()
        default:
            locationManager.delegate = self
            getLocation()
            welcomeStackView.isHidden = true
            if hasPlacemark() {
                isInRange(completion: { (inRange: Bool) in
                    if inRange {
                        self.preloadDaysFromCoreData()
                        if DataSource.calendar.count == 0 {
                            self.getCalendarFromAPIToCoreData(placemark: DataSource.currentPlacemark, completion: {
                                self.createNotificationFromCalendar {
                                    self.activityIndicator.stopAnimating()
                                    self.presentMain()
                                }
                            })
                        } else {
                            self.activityIndicator.stopAnimating()
                            self.presentMain()
                        }
                    } else {
                        self.updateLocation()
                    }
                })
            } else {
                activityIndicator.stopAnimating()
                getLocation()
            }
            
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
    
    func updateLocation() {
        getPlacemark {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            self.setupUserNotification()
        }
    }
    
    func getLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            presentDisabledLocationServiceAlert()
            welcomeStackView.isHidden = false
        }
    }
    
    func getPlacemark(completion: @escaping () -> Void) {
        
        CLGeocoder().reverseGeocodeLocation(currentLocation!) { (placemarks: [CLPlacemark]?, error: Error?) in
            guard error == nil else { return }
            
            let placemark = placemarks![0]
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: placemark)
            let userDefaults = UserDefaults.standard
            userDefaults.set(encodedData, forKey: "placemark")
            
            DataSource.currentPlacemark = placemark
            
            self.getCalendarFromAPIToCoreData(placemark: placemark) {
                completion()
            }
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
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            
            executeOnMain(withDelay: 1.0, {
                let location = self.currentLocation!
                
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
        
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings: UNNotificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .authorized:
                self.createNotificationFromCalendar {
                    self.activityIndicator.stopAnimating()
                    self.presentMain()
                }
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (didAllow: Bool, error: Error?) in
                    if didAllow {
                        self.createNotificationFromCalendar {
                            self.activityIndicator.stopAnimating()
                            self.presentMain()
                        }
                    } else {
                        self.activityIndicator.stopAnimating()
                        self.presentDeniedNotificationAccessAlert()
                    }
                }
            case .denied:
                self.activityIndicator.stopAnimating()
                self.presentDeniedNotificationAccessAlert()
                
            }
        }
    }
    
    func presentDeniedLocationAccessAlert() {
        let alert = UIAlertController(title: "Location Access Denied", message: "For better experience, you can turn on your location permission in Settings > Pray Tracker > Location", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Go To Settings", style: .default, handler: { (action: UIAlertAction) in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentDisabledLocationServiceAlert() {
        let alert = UIAlertController(title: "Location Service Disabled", message: "For better experience, you can turn on your location service in Settings > Privacy > Location Services", preferredStyle: .alert)
        
        let goToSettingsAction = UIAlertAction(title: "Go To Settings", style: .destructive, handler: { (action: UIAlertAction) in
            let locationServiceURL = URL(string: "App-Prefs:root=LOCATION_SERVICES")!
            if UIApplication.shared.canOpenURL(locationServiceURL) {
                UIApplication.shared.open(locationServiceURL, completionHandler: { (success: Bool) in
                    self.initialSetup()
                })
            }
        })
        
        let tryAgainAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default) { (action: UIAlertAction) in
            self.initialSetup()
        }
        
        alert.addAction(goToSettingsAction)
        alert.addAction(tryAgainAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentDeniedNotificationAccessAlert() {
        let alert = UIAlertController(title: "Notification Access Denied", message: "For better experience, you can turn on your notification permission in Settings", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
            self.presentMain()
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Mark: Notification
    func createNotification(with timeInterval: Double, timingName: String, readableDate: String) {
//        let remindIn15Mins = UNNotificationAction(identifier: "remindIn15Mins", title: "Remind me in 15 minutes", options: .destructive)
//        let done = UNNotificationAction(identifier: "done", title: "Done", options: .foreground)
//        let category = UNNotificationCategory(identifier: "default", actions: [remindIn15Mins, done], intentIdentifiers: [], options: [])
//        UNUserNotificationCenter.current().setNotificationCategories([category])
        
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


