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

class InitialViewController: UIViewController {

    @IBOutlet weak var backgroundPatternImageView: UIImageView!
    
    let locationManager = CLLocationManager()
    
    var loadingView = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundPatternImageView.imageGradientFadeTop(target: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if hasPlacemark() {
            preloadDaysFromCoreData()
            if DataSource.calendar.count == 0 {
                getCalendarFromAPIToCoreData(placemark: DataSource.currentPlacemark, completion: {
                    self.presentMain()
                })
            } else {
                self.presentMain()
            }
        } else {
            getPlacemark()
        }
    }
    
    func getPlacemark() {
        locationManager.delegate = self
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func hasPlacemark() -> Bool {
        
        if let placemarkData  = UserDefaults.standard.object(forKey: "placemark") as? Data {
            let placemark = NSKeyedUnarchiver.unarchiveObject(with: placemarkData) as! CLPlacemark
            DataSource.currentPlacemark = placemark
            return true
        } else {
            return false
        }
    }
    
    func presentMain() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let main = storyboard.instantiateViewController(withIdentifier: "Main") as! UINavigationController
        self.present(main, animated: false, completion: nil)
    }
    
    
}

// The Delegate

extension InitialViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        locationManager.stopUpdatingLocation()
        CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks: [CLPlacemark]?, error: Error?) in
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
                self.executeOnMain {
                    self.presentMain()
                }
                
            }
        }
    }
}

