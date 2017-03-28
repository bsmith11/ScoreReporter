//
//  DateFormatter+Extensions.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 3/28/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation

public extension DateFormatter {
    static let eventDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "M/d/y h:mm:ss a"
        
        return dateFormatter
    }()
    
    static let eventSearchDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        return dateFormatter
    }()
    
    static let gameDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "M/d/y"
        
        return dateFormatter
    }()
    
    static let gameTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "h:mm a"
        
        return dateFormatter
    }()
    
    static let gameStartDateFullFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "E h:mm a"
        
        return dateFormatter
    }()
    
    static let eventDetailsDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "MMM dd"
        
        return dateFormatter
    }()
}
