//
//  Timing+CoreDataClass.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/21/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import CoreData

@objc(Timing)
public class Timing: NSManagedObject {

    convenience init(dictionary: NSDictionary, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "Timing", in: context) {
            self.init(entity: entity, insertInto: context)
            
            guard
                let imsakTime = dictionary["Imsak"] as? String,
                let fajrTime = dictionary["Fajr"] as? String,
                let dhuhrTime = dictionary["Dhuhr"] as? String,
                let asrTime = dictionary["Asr"] as? String,
                let maghribTime = dictionary["Maghrib"] as? String,
                let ishaTime = dictionary["Isha"] as? String else {
                fatalError("Unable to find Timing value ")
            }
            
            self.imsak = imsakTime.formatToDate()
            self.fajr = fajrTime.formatToDate()
            self.dhuhr = dhuhrTime.formatToDate()
            self.asr = asrTime.formatToDate()
            self.maghrib = maghribTime.formatToDate()
            self.isha = ishaTime.formatToDate()
            
        } else {
            fatalError("Unable to find the entity named Timing")
        }
    }
}
