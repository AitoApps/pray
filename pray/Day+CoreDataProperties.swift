//
//  Day+CoreDataProperties.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/22/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var readable: String?
    @NSManaged public var timings: Timings?

}
