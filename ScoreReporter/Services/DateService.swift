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
    private static let gameStartDateFullFormat = "E h:mm a"

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
    
    static let gameStartDateFullFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = gameStartDateFullFormat
        
        return dateFormatter
    }()
}
