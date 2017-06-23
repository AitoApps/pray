//
//  QiblaLocator.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/23/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import MapKit

class QiblaLocator {
    
    let qiblaLocation = CLLocation(latitude: 21.4228394, longitude: 39.8250211)
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {
        
        let latitude = degreesToRadians(degrees: point1.coordinate.latitude)
        let longitude = degreesToRadians(degrees: point1.coordinate.longitude)
        
        let qiblaLatitude = degreesToRadians(degrees: qiblaLocation.coordinate.latitude)
        let qiblaLongitude = degreesToRadians(degrees: qiblaLocation.coordinate.longitude)
        
        let differentLongitude = qiblaLongitude - longitude
        
        let y = sin(differentLongitude) * cos(qiblaLatitude)
        let x = cos(latitude) * sin(qiblaLatitude) - sin(latitude) * cos(qiblaLatitude) * cos(differentLongitude)
        let radiansBearing = atan2(y, x)
        
        return radiansToDegrees(radians: radiansBearing)
    }

}
