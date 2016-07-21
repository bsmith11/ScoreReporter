//
//  NSDate+Extensions.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

extension NSDate {
    static func dateWithDate(date: NSDate?, time: NSDate?) -> NSDate? {
        guard let date = date,
            time = time else {
            return nil
        }

        let calendar = NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone(abbreviation: "UTC")!

        let dateComponents = calendar.components([.Day, .Month, .Year], fromDate: date)
        let timeComponents = calendar.components([.Hour, .Minute], fromDate: time)

        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute

        return calendar.dateFromComponents(dateComponents)
    }
}
