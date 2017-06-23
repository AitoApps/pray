//
//  DataSource.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/21/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class DataSource: NSObject {
    static var calendar = [Day]()
    static var currentPlacemark: CLPlacemark!
    
    class func today() -> Day? {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let today = dateFormatter.string(from: date)
        for day in calendar {
            if day.readableDate == today {
                return day
            }
        }
        return nil
    }
}







