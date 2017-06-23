//
//  Timing+CoreDataClass.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/23/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import CoreData

@objc(Timing)
public class Timing: NSManagedObject {

    @discardableResult convenience init(stringTime: String, for time: Time, at day: Day, insertInto context: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Timing", in: context) else {
            fatalError("Unable to find the entity named Timing")
        }
        
        self.init(entity: entity, insertInto: context)
        
        switch time {
        case .Imsak:
            self.name = Time.Imsak.rawValue
        case .Fajr:
            self.name = Time.Fajr.rawValue
        case .Sunrise:
            self.name = Time.Sunrise.rawValue
        case .Dhuhr:
            self.name = Time.Dhuhr.rawValue
        case .Asr:
            self.name = Time.Asr.rawValue
        case .Maghrib:
            self.name = Time.Maghrib.rawValue
        case .Isha:
            self.name = Time.Isha.rawValue
        }
        
        self.date = stringTime.formatTimeToNSDate(day: day)
        self.readableDate = stringTime
        self.day = day
    }
    
}
