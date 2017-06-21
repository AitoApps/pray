//
//  Timing+CoreDataProperties.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/21/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import CoreData


extension Timing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Timing> {
        return NSFetchRequest<Timing>(entityName: "Timing")
    }

    @NSManaged public var fajr: NSDate?
    @NSManaged public var sunrise: NSDate?
    @NSManaged public var dhuhr: NSDate?
    @NSManaged public var asr: NSDate?
    @NSManaged public var maghrib: NSDate?
    @NSManaged public var isha: NSDate?
    @NSManaged public var imsak: NSDate?
    @NSManaged public var midnight: NSDate?

}
