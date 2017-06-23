//
//  LocationDelegate.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/23/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import MapKit

class LocationDelegate: NSObject, CLLocationManagerDelegate {
    var locationCallback: ((CLLocation) -> ())? = nil
    var headingCallback: ((CLLocationDirection) -> ())? = nil
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        locationCallback?(currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        headingCallback?(newHeading.trueHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("⚠️ Error while updating location " + error.localizedDescription)
    }
}
