//
//  StringFormatter.swift
//  pray
//
//  Created by Zulwiyoza Putra on 5/25/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation

extension String {
    func formatTimeToNSDate(day: Day) -> NSDate {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm, dd MMM yyyy"
        print(self)
        let timeZoneIdentifier = self.components(separatedBy: " ")[1].components(separatedBy: "(")[1].components(separatedBy: ")")[0]
        
        let timeComponent = self.components(separatedBy: " ")[0]
        
        dateFormatter.timeZone = TimeZone(identifier: timeZoneIdentifier)
        
        let date = dateFormatter.date(from: "\(timeComponent), \(day.readable!)")! as NSDate
        
        return date
    }
}
