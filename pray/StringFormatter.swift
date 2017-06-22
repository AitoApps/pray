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
        dateFormatter.dateFormat = "HH:mm (zzz), dd MMM yyyy"


        let date = dateFormatter.date(from: "\(self), \(day.readable!)")! as NSDate
        
        return date
    }
}
