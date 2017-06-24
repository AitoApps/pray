//
//  DateToStringFormatter.swift
//  pray
//
//  Created by Zulwiyoza Putra on 6/24/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation

extension Date {
    func formatTimeToReadableTime() -> String  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        return dateFormatter.string(from: self)
    }
}
