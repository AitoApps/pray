//
//  Timings+CoreDataClass.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/22/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import CoreData

@objc(Timings)
public class Timings: NSManagedObject {
    
    convenience init(dictionary: [String: AnyObject], timestamp: String, insertInto context: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Timings", in: context) else {
            fatalError("Unable to find the entity named Timings")
        }
        
        let day = Day(timestamp: timestamp, insertInto: context)
        
        self.init(entity: entity, insertInto: context)
        
        guard
            let midnightTime = dictionary["Midnight"] as? String,
            let imsakTime = dictionary["Imsak"] as? String,
            let sunriseTime = dictionary["Sunrise"] as? String,
            let fajrTime = dictionary["Fajr"] as? String,
            let dhuhrTime = dictionary["Dhuhr"] as? String,
            let asrTime = dictionary["Asr"] as? String,
            let maghribTime = dictionary["Maghrib"] as? String,
            let ishaTime = dictionary["Isha"] as? String else {
                fatalError("Unable to find Timing value ")
        }
        
        self.midnight = midnightTime.formatTimeToNSDate(day: day)
        self.imsak = imsakTime.formatTimeToNSDate(day: day)
        self.fajr = fajrTime.formatTimeToNSDate(day: day)
        self.sunrise = sunriseTime.formatTimeToNSDate(day: day)
        self.dhuhr = dhuhrTime.formatTimeToNSDate(day: day)
        self.asr = asrTime.formatTimeToNSDate(day: day)
        self.maghrib = maghribTime.formatTimeToNSDate(day: day)
        self.isha = ishaTime.formatTimeToNSDate(day: day)
        self.day = day
        
        

    }

}
