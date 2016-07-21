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
    let startMonth: String
    let startDay: String

    init(event: Event?) {
        name = event?.name ?? "No Name"
        
        let city = event?.city ?? "City"
        let state = event?.state ?? "State"
        location = "\(city), \(state)"

        let baseURL = "http://play.usaultimate.org/"
        logoURL = event?.logoPath.flatMap({NSURL(string: "\(baseURL)\($0)")})

        let startDate = event?.startDate ?? NSDate()
        startMonth = DateService.monthDateFormatter.stringFromDate(startDate)
        startDay = DateService.dayDateFormatter.stringFromDate(startDate)
    }
}
