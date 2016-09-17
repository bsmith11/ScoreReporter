//
//  EventViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

struct EventViewModel {
    let name: String
    let location: String
    let logoURL: NSURL?
    let startDay: String
    let startMonth: String
    let eventDate: String

    init(event: Event?) {
        name = event?.name ?? "No Name"
        
        let city = event?.city ?? "City"
        let state = event?.state ?? "State"
        location = "\(city), \(state)"

        let baseURL = "http://play.usaultimate.org/"
        logoURL = event?.logoPath.flatMap({NSURL(string: "\(baseURL)\($0)")})

        let startDate = event?.startDate ?? NSDate()
        startDay = DateService.dayDateFormatter.stringFromDate(startDate)
        startMonth = DateService.monthDateFormatter.stringFromDate(startDate)
        eventDate = DateService.eventDateFormatter.stringFromDate(startDate)
    }
}
