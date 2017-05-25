//
//  QiblaViewController.swift
//  pray
//
//  Created by Zulwiyoza Putra on 5/24/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class QiblaViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var userRegion: MKCoordinateRegion? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUserCurrentLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showCurrentLocation(_ sender: Any) {
        getUserCurrentLocation()
    }
    
    func getAuthorizationForLocation(completion: @escaping (_ success: Bool) -> Void) {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            completion(true)
        } else {
            completion(false)
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func getUserCurrentLocation() {
        getAuthorizationForLocation { (success) in
            if success {
                self.locationManager.startUpdatingLocation()
                self.showCurrentRegionOnTheMap()
                
                
            } else {
                self.getAuthorizationForLocation(completion: { (success) in
                    if success {
                        self.getUserCurrentLocation()
                    } else {
                        print("User doesn't authorized the location access")
                    }
                })
            }
        }
    }
    
    func showCurrentRegionOnTheMap() {
        if let region = self.userRegion {
            self.mapView.setRegion(region, animated: true)
        } else {
            if let location = locationManager.location {
                currentlocation = location
                let locationCoordinateSpan = MKCoordinateSpanMake(0.025, 0.025)
                let userLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                let region = MKCoordinateRegionMake(userLocation, locationCoordinateSpan)
                userRegion = region
                self.mapView.showsUserLocation = true
                self.mapView.showsPointsOfInterest = true
                self.mapView.showsCompass = true
                self.mapView.setRegion(region, animated: true)
            }
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let locationCoordinateSpan = MKCoordinateSpanMake(0.025, 0.025)
        let userLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        userRegion = MKCoordinateRegionMake(userLocation, locationCoordinateSpan)
        self.mapView.showsUserLocation = true
        self.mapView.showsPointsOfInterest = true
        self.mapView.showsCompass = true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            getUserCurrentLocation()
        }
    }
    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
