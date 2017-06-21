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
    
    // BUG LISTS
    // VIEW NOT UPDATING IF USER INITIAL OPEN THE APP
    
    struct DailyTiming {
        
        var FajrTime: Date
        var SunriseTime: Date
        var DhuhrTime: Date
        var AsrTime: Date
        var MaghribTime: Date
        var IshaTime: Date
        var ImsakTime: Date
        
        init(dictionary: [String: AnyObject], stringDate: String) {
            let stringFajrTime = dictionary["Fajr"] as! String
            self.FajrTime = stringFajrTime.stringToDate(stringDate: stringDate)
            
            let stringSunriseTime = dictionary["Sunrise"] as! String
            self.SunriseTime = stringSunriseTime.stringToDate(stringDate: stringDate)
            
            let stringDhuhrTime = dictionary["Dhuhr"] as! String
            self.DhuhrTime = stringDhuhrTime.stringToDate(stringDate: stringDate)
            
            let stringAsrTime = dictionary["Asr"] as! String
            self.AsrTime = stringAsrTime.stringToDate(stringDate: stringDate)
            
            let stringMaghribTime = dictionary["Maghrib"] as! String
            self.MaghribTime = stringMaghribTime.stringToDate(stringDate: stringDate)
            
            let stringIshaTime = dictionary["Isha"] as! String
            self.IshaTime = stringIshaTime.stringToDate(stringDate: stringDate)
            
            let stringImsakTime = dictionary["Imsak"] as! String
            self.ImsakTime = stringImsakTime.stringToDate(stringDate: stringDate)
        }
    }
    
    static var calendar: [[String: AnyObject]]? = nil {
        didSet {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            let todayDate = dateFormatter.string(from: date)
            print(todayDate)
            let index = Int(todayDate)! - 1

            
            guard let timings = calendar else {
                return
            }
            
            let today = timings[index] as [String: AnyObject]
            let todayTimingsDictionary = today["timings"] as! [String: AnyObject]

            Timing.today = Timing.DailyTiming.init(dictionary: todayTimingsDictionary, stringDate: todayDate)
        }
    }
    
    static var today: DailyTiming? = nil
    
    override init() {
        super.init()
    }
    
    static func dateToStringTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "K:mm a"
        let stringTime = dateFormatter.string(from: date)
        return stringTime
    }
    
    static func fetchCalendar(location: CLLocation, completion: @escaping (_ calendar: ([[String: AnyObject]])?, _ error: NSError?) -> Void) {
        
        let latitude = location.coordinate.latitude.description
        let longitude = location.coordinate.longitude.description
        
        guard let timeZone = Location.currentTimeZone else {
            return
        }
        
        
        let date = Date()
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let year = yearFormatter.string(from: date)
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        let month = monthFormatter.string(from: date)
        
        let parameters = [
            "latitude": latitude,
            "longitude": longitude,
            "timezonestring": timeZone,
            "method": "2",
            "month": month,
            "year": year,
            ]
        
        AladhanAPI.taskForGETMethod(parameters: parameters as [String : AnyObject], method: "calendar", completion: { (result, error) in
            
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
