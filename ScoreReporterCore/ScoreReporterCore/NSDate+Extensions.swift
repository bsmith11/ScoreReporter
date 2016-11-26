//
//  NSDate+Extensions.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

public extension Date {
    static func date(fromDate date: Date?, time: Date?) -> Date? {
        guard let date = date,
              let time = time else {
            return nil
        }

        guard let timeZone = TimeZone(abbreviation: "UTC") else {
            print("Failed to initialize UTC timezone")
            return nil
        }

        var calendar = Calendar.current
        calendar.timeZone = timeZone

        var dateComponents = calendar.dateComponents([.day, .month, .year], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)

        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute

        return calendar.date(from: dateComponents)
    }

    static var enclosingDatesForCurrentWeek: (Date, Date) {
        var calendar = Calendar.current
        calendar.firstWeekday = 2

        var startDate: NSDate? = nil
        var interval: TimeInterval = 0.0
        (calendar as NSCalendar).range(of: .weekOfYear, start: &startDate, interval: &interval, for: Date())

        let endDate = startDate?.addingTimeInterval(interval)

        let start = startDate as? Date ?? Date()
        let end = endDate as? Date ?? Date()

        return (start, end)
    }
}
