//
//  Timing+CoreDataProperties.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/23/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import CoreData


extension Timing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Timing> {
        return NSFetchRequest<Timing>(entityName: "Timing")
    }

    @NSManaged public var name: String?
    @NSManaged public var readableDate: String?
    @NSManaged public var readableCompletionDate: String?
    @NSManaged public var completionDate: NSDate?
    @NSManaged public var date: NSDate?
    @NSManaged public var day: Day?

}
