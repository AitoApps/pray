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

var currentlocation: CLLocation? = nil

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let locationCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        currentlocation = locationManager.location
        let userLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region = MKCoordinateRegionMake(userLocation, locationCoordinateSpan)
    }

}

