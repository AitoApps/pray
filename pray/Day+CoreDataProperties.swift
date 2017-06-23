//
//  Day+CoreDataProperties.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/23/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var readableDate: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var timings: NSSet?

}

// MARK: Generated accessors for timings
extension Day {

    @objc(addTimingsObject:)
    @NSManaged public func addToTimings(_ value: Timing)

    @objc(removeTimingsObject:)
    @NSManaged public func removeFromTimings(_ value: Timing)

    @objc(addTimings:)
    @NSManaged public func addToTimings(_ values: NSSet)

    @objc(removeTimings:)
    @NSManaged public func removeFromTimings(_ values: NSSet)

}
