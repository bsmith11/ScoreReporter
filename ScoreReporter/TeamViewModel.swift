//
//  TeamViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreLocation

struct TeamViewModel {
    let name: String
    let state: String
    let location: String
    let coordinate: CLLocationCoordinate2D?
    let logoURL: URL?
    
    init(team: Team?) {
        name = team?.name ?? "No Name"
        
        self.state = TeamViewModel.stateNameForAbbreviation(team?.state) ?? team?.state ?? "No State"
        
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
        logoURL = team?.logoPath.flatMap({URL(string: "\(baseURL)\($0)")})
    }
    
    static func stateNameForAbbreviation(_ abbreviation: String?) -> String? {
        guard let abbreviation = abbreviation else {
            return nil
        }
        
        let states = [
            "AL": "Alabama",
            "AK": "Alaska",
            "AZ": "Arizona",
            "AR": "Arkansas",
            "CA": "California",
            "CO": "Colorado",
            "CT": "Connecticut",
            "DE": "Delaware",
            "DC": "District of Columbia",
            "FL": "Florida",
            "GA": "Georgia",
            "HI": "Hawaii",
            "ID": "Idaho",
            "IL": "Illinois",
            "IN": "Indiana",
            "IA": "Iowa",
            "KS": "Kansas",
            "KY": "Kentucky",
            "LA": "Louisiana",
            "ME": "Maine",
            "MD": "Maryland",
            "MA": "Massachusetts",
            "MI": "Michigan",
            "MN": "Minnesota",
            "MS": "Mississippi",
            "MO": "Missouri",
            "MT": "Montana",
            "NE": "Nebraska",
            "NV": "Nevada",
            "NH": "New Hampshire",
            "NJ": "New Jersey",
            "NM": "New Mexico",
            "NY": "New York",
            "NC": "North Carolina",
            "ND": "North Dakota",
            "OH": "Ohio",
            "OK": "Oklahoma",
            "OR": "Oregon",
            "PA": "Pennsylvania",
            "RI": "Rhode Island",
            "SC": "South Carolina",
            "SD": "South Dakota",
            "TN": "Tennessee",
            "TX": "Texas",
            "UT": "Utah",
            "VT": "Vermont",
            "VA": "Virginia",
            "WA": "Washington",
            "WV": "West Virginia",
            "WI": "Wisconsin",
            "WY": "Wyoming",
            
            "AB": "Alberta",
            "BC": "British Columbia",
            "MB": "Manitoba",
            "NB": "New Brunswick",
            "NL": "Newfoundland",
            "NS": "Nova Scotia",
            "NT": "Northwest Territories",
            "NU": "Nunavut",
            "ON": "Ontario",
            "PE": "Prince Edward Island",
            "QC": "Quebec",
            "SK": "Saskatchewan",
            "YT": "Yukon"
        ]
        
        return states[abbreviation]
    }
}
