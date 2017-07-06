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

class InitialViewController: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet weak var backgroundPatternImageView: UIImageView!
    
    let locationManager = CLLocationManager()
    
    var loadingView = LoadingView()
    
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
        allowNotificationAccessButton.isEnabled = false
        
        UNUserNotificationCenter.current().delegate = self
        
        allowLocationAccessButton.addTarget(self, action: #selector(getLocation), for: .touchUpInside)
        allowNotificationAccessButton.addTarget(self, action: #selector(setupUserNotification), for: .touchUpInside)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if hasPlacemark() {
            
            allowLocationAccessButton.removeFromSuperview()
            allowNotificationAccessButton.removeFromSuperview()
            
            hasSamePlacemark(completion: { (same: Bool) in
                if same {
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
        
        allowLocationAccessButton.setTitle("", for: UIControlState.normal)
        allowLocationAccessButton.isEnabled = false
        allowLocationAccessButton.activityIndicator(show: true)
        
        getPlacemark {
            self.executeOnMain {
                self.allowLocationAccessButton.activityIndicator(show: false)
                let placemark = DataSource.currentPlacemark
                self.allowLocationAccessButton.setTitle(placemark?.subAdministrativeArea ?? placemark?.locality, for: UIControlState.normal)
                self.allowLocationAccessButton.backgroundColor = UIColor.white
                self.allowLocationAccessButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
                self.allowNotificationAccessButton.isEnabled = true
            }
        }
    }
    
    func getPlacemark(completion: @escaping () -> Void) {
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
            let location = locationManager.location!
            
            locationManager.stopUpdatingLocation()
            
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: Error?) in
                guard error == nil else {
                    print("No Locaton Returned")
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
        }
    }
    
    func hasPlacemark() -> Bool {
        if (UserDefaults.standard.object(forKey: "placemark") as? Data) != nil {
            return true
        } else {
            return false
        }
    }
    
    func hasSamePlacemark(completion: @escaping (Bool) -> Void) {
        
        guard let placemarkData = UserDefaults.standard.object(forKey: "placemark") as? Data else {
            completion(false)
            return
        }
        
        let placemark = NSKeyedUnarchiver.unarchiveObject(with: placemarkData) as! CLPlacemark
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
            let location = locationManager.location!
            
            
            
            locationManager.stopUpdatingLocation()
            
            print(location)
            
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: Error?) in
                
                if error == nil {
                    let currentPlacemark = placemarks![0]
                    
                    if currentPlacemark.locality == placemark.locality || currentPlacemark.subAdministrativeArea == placemark.subAdministrativeArea {
                        DataSource.currentPlacemark = placemark
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
    
    func presentMain() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let main = storyboard.instantiateViewController(withIdentifier: "Main") as! UINavigationController
        self.present(main, animated: false, completion: nil)
    }
    
    
    func setupUserNotification() {
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings: UNNotificationSettings) in
            if notificationSettings.authorizationStatus != .authorized {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (didAllow: Bool, error: Error?) in
                    if didAllow {
                        print("Allowed")
                        self.createNotificationFromCalendar {
                            self.presentMain()
                        }
                    } else {
                        print("Not allowed please go to settings to allow notification")
                    }
                }
            } else {
                self.createNotificationFromCalendar {
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
                print("Error adding notification request in notification center")
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

extension InitialViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let _ = locations[0]
        locationManager.stopUpdatingLocation()
    }
}

