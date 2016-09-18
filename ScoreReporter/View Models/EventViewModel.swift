//
//  EventViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreLocation

struct EventViewModel {
    let name: String
    let location: String
    let address: String
    let coordinate: CLLocationCoordinate2D?
    let logoURL: NSURL?
    let eventDate: String

    init(event: Event?) {
        name = event?.name ?? "No Name"
        
        let city = event?.city ?? "City"
        let state = event?.state ?? "State"
        location = "\(city), \(state)"
        
        address = location
        
        if let latitude = event?.latitude,
               longitude = event?.longitude {
            coordinate = CLLocationCoordinate2D(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
        }
        else {
            coordinate = nil
        }

        let baseURL = "http://play.usaultimate.org/"
        logoURL = event?.logoPath.flatMap({NSURL(string: "\(baseURL)\($0)")})

        let startDate = event?.startDate ?? NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        eventDate = dateFormatter.stringFromDate(startDate)
    }
}
