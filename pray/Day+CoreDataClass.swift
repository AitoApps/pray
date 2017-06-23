//
//  Day+CoreDataClass.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/23/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import CoreData

@objc(Day)
public class Day: NSManagedObject {
    
    convenience init(unixTime: String, insertInto context: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Day", in: context) else {
            fatalError("Unable to find the entity named Day")
        }
        
        self.init(entity: entity, insertInto: context)
        
        let date = NSDate(timeIntervalSince1970: TimeInterval(unixTime)!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        self.readableDate = dateFormatter.string(from: date as Date)
        self.date = date
    }

}
