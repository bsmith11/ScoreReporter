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
    
    let fullInfo: String
    
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
        
        logoURL = team?.searchLogoURL
        
        var fullInfo = ""
        
        if let id = team?.teamID.stringValue {
            fullInfo.append("\nID: \(id)")
        }
        
        if let school = team?.school {
            fullInfo.append("\nSchool: \(school)")
        }
        
        if let division = team?.division {
            fullInfo.append("\nDivision: \(division)")
        }
        
        if let compLevel = team?.competitionLevel {
            fullInfo.append("\nComp Level: \(compLevel)")
        }
        
        if let desig = team?.designation {
            fullInfo.append("\nDesig: \(desig)")
        }
        
        self.fullInfo = fullInfo
    }
}
