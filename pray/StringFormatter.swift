//
//  StringFormatter.swift
//  pray
//
//  Created by Zulwiyoza Putra on 5/25/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation

extension String {
    func stringToDate(stringDate: String)  -> Date {
        print(stringDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm (zzz), dd MMM yyyy"
        let stringDate = "\(self), \(stringDate)"
        let date = dateFormatter.date(from: stringDate)
        return date!
    }
}
