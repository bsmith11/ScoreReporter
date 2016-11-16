//
//  DateService.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

public struct DateService {
    fileprivate static let eventDateFormat = "M/d/y h:mm:ss a"
    fileprivate static let gameDateFormat = "M/d/y"
    fileprivate static let gameTimeFormat = "h:mm a"
    fileprivate static let gameStartDateFullFormat = "E h:mm a"

    public static let eventDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = eventDateFormat

        return dateFormatter
    }()

    public static let gameDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = gameDateFormat

        return dateFormatter
    }()

    public static let gameTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = gameTimeFormat

        return dateFormatter
    }()
    
    public static let gameStartDateFullFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = gameStartDateFullFormat
        
        return dateFormatter
    }()
}
