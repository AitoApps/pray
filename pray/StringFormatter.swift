//
//  StringFormatter.swift
//  pray
//
//  Created by Zulwiyoza Putra on 5/25/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation

extension String {
    func formatToDate() -> NSDate {
        
        let today = Date()
        let todayFormatter = DateFormatter()
        todayFormatter.dateFormat = "dd MMM yyyy"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm (zzz), dd MMM yyyy"

        let date = dateFormatter.date(from: "\(self), \(todayFormatter.string(from: today))")! as NSDate
        
        return date
    }
}
