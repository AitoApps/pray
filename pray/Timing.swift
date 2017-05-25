//
//  Timing.swift
//  pray
//
//  Created by Zulwiyoza Putra on 5/25/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class Timing: NSObject {
    
    struct dailyTiming {
        var Fajr: String
        var Sunrise: String
        var Dhuhr: String
        var Asr: String
        var Maghrib: String
        var Isha: String
        var Imsak: String
    }
    
    
    static var calendar = [[String: AnyObject]]()
    static var today = [String: AnyObject]()
    
    override init() {
        super.init()
    }
    
    static func fetchCalendar(location: CLLocation, completion: @escaping (_ calendar: ([[String: AnyObject]])?, _ error: NSError?) -> Void) {
        
        let latitude = location.coordinate.latitude.description
        let longitude = location.coordinate.longitude.description
        
        guard let timeZone = Location.currentTimeZone else {
            return
        }
        
        let parameters = [
            "latitude": latitude,
            "longitude": longitude,
            "timezonestring": timeZone,
            "method": "2",
            "month": "6",
            "year": "2017",
            ]
        
        AladhanClient.taskForGETMethod(parameters: parameters as [String : AnyObject], method: "calendar", completion: { (result, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error.debugDescription)")
                return
            }
            
            guard let data = result!["data"] as? [[String : AnyObject]] else {
                sendError("No data was returned by the request!")
                return
            }
            
            completion(data, nil)
            
        })
    }

}
