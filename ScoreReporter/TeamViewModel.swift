//
//  TeamViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreLocation
import ScoreReporterCore

struct TeamViewModel {
    let name: String
    let state: String
    let location: String
    let coordinate: CLLocationCoordinate2D?
    let logoURL: URL?
    
    init(team: Team?) {
        name = team?.name ?? "No Name"
        
        self.state = Team.stateName(fromAbbreviation: team?.state) ?? team?.state ?? "No State"
        
        let city = team?.city ?? "City"
        let state = team?.state ?? "State"
        location = "\(city), \(state)"
        
        coordinate = nil
        
//        if let latitude = event?.latitude,
//            longitude = event?.longitude {
//            coordinate = CLLocationCoordinate2D(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
//        }
//        else {
//            coordinate = nil
//        }
        
        let baseURL = "http://play.usaultimate.org"
        logoURL = team?.logoPath.flatMap { URL(string: "\(baseURL)\($0)") }
    }
}
