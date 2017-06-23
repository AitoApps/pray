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
    
    private static let qiblaLocation = CLLocation(latitude: 21.4228394, longitude: 39.8250211)
    
    class func bearingRadian(location: CLLocation) -> CGFloat {
        
        let latitude = location.coordinate.latitude.degreesToRadians
        let longitude = location.coordinate.longitude.degreesToRadians
        
        let qiblaLatitude = self.qiblaLocation.coordinate.latitude.degreesToRadians
        let qiblaLongitude = self.qiblaLocation.coordinate.longitude.degreesToRadians
        
        let differentLongitude = qiblaLongitude - longitude
        
        let y = sin(differentLongitude) * cos(qiblaLatitude)
        let x = cos(latitude) * sin(qiblaLatitude) - sin(latitude) * cos(qiblaLatitude) * cos(differentLongitude)
        let radiansBearing = atan2(y, x)
        
        return CGFloat(radiansBearing)
    }
    
    class func bearingDegrees(location: CLLocation) -> CGFloat {
        return QiblaLocator.bearingRadian(location: location).radiansToDegrees
    }

}

extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}

private extension Double {
    var degreesToRadians: Double { return Double(CGFloat(self).degreesToRadians) }
    var radiansToDegrees: Double { return Double(CGFloat(self).radiansToDegrees) }
}
