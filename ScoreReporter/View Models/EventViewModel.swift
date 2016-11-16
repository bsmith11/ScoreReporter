//
//  EventViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreLocation
import ScoreReporterCore

struct EventViewModel {
    let name: String
    let location: String
    let address: String
    let coordinate: CLLocationCoordinate2D?
    let logoURL: URL?
    let eventStartDate: String
    let eventDates: String
    let groups: [Group]
    let event: Event?

    init(event: Event?) {
        name = event?.name ?? "No Name"
        
        let city = event?.city ?? "City"
        let state = event?.state ?? "State"
        location = "\(city), \(state)"
        
        address = location
        
        if let latitude = event?.latitude,
               let longitude = event?.longitude {
            coordinate = CLLocationCoordinate2D(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
        }
        else {
            coordinate = nil
        }

        let baseURL = "http://play.usaultimate.org/"
        logoURL = event?.logoPath.flatMap { URL(string: "\(baseURL)\($0)") }

        let startDate = event?.startDate ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        eventStartDate = dateFormatter.string(from: startDate)
        
        let endDate = event?.endDate ?? Date()
        eventDates = "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
        
        let groups = event?.groups as? Set<Group> ?? []
        self.groups = groups.sorted(by: {$0.0.groupID.intValue < $0.1.groupID.intValue})
        
        self.event = event
    }
}
