//
//  NSDate+Extensions.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

public extension Date {
//    init?(date: Date?, time: Date?) {
//        guard let date = date,
//              let time = time else {
//            return nil
//        }
//        
//        var calendar = Calendar.current
//        calendar.timeZone = TimeZone(abbreviation: "UTC")!
//        
//        var dateComponents = (calendar as NSCalendar).components([.day, .month, .year], from: date)
//        let timeComponents = (calendar as NSCalendar).components([.hour, .minute], from: time)
//        
//        dateComponents.hour = timeComponents.hour
//        dateComponents.minute = timeComponents.minute
//        
//        let newDate = calendar.date(from: dateComponents)
//        
//        self.init()
//    }
    
    static func date(fromDate date: Date?, time: Date?) -> Date? {
        guard let date = date,
              let time = time else {
            return nil
        }

        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!

        var dateComponents = (calendar as NSCalendar).components([.day, .month, .year], from: date)
        let timeComponents = (calendar as NSCalendar).components([.hour, .minute], from: time)

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
