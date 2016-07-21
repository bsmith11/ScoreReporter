//
//  DateService.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

struct DateService {
    private static let eventDateFormat = "M/d/y h:mm:ss a"
    private static let gameDateFormat = "M/d/y"
    private static let gameTimeFormat = "h:mm a"
//    static NSString * const kSTKEventGameDisplayDateFormat = @"E h:mm a";

    static let eventDateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = eventDateFormat

        return dateFormatter
    }()

    static let gameDateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = gameDateFormat

        return dateFormatter
    }()

    static let gameTimeFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = gameTimeFormat

        return dateFormatter
    }()

    static let monthDateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM"

        return dateFormatter
    }()

    static let dayDateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d"

        return dateFormatter
    }()
}
