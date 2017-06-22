//
//  Timings+CoreDataProperties.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/22/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import CoreData


extension Timings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Timings> {
        return NSFetchRequest<Timings>(entityName: "Timings")
    }

    @NSManaged public var asr: NSDate?
    @NSManaged public var dhuhr: NSDate?
    @NSManaged public var fajr: NSDate?
    @NSManaged public var imsak: NSDate?
    @NSManaged public var isha: NSDate?
    @NSManaged public var maghrib: NSDate?
    @NSManaged public var midnight: NSDate?
    @NSManaged public var sunrise: NSDate?
    @NSManaged public var day: Day?

}
