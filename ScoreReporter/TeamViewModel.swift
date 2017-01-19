//
//  TeamViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import ScoreReporterCore

extension Sequence where Iterator.Element == String? {
    func joined(by separator: String) -> String? {
        let string = flatMap { $0 }.joined(separator: separator)
        return string.isEmpty ? nil : string
    }
}

struct TeamViewModel {
    let fullName: String?
    let competitionDivision: String?
    let location: String?
    let logoURL: URL?

    init(team: Team?) {
        fullName = [team?.school, team?.name].joined(by: " ")
        
        competitionDivision = [team?.competitionLevel, team?.division].joined(by: " ")
        
        if let city = team?.city, let state = team?.state {
            location = "\(city), \(state)"
        }
        else {
            location = nil
        }
        
        logoURL = team?.searchLogoURL
    }
}
