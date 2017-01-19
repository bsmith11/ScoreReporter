//
//  TeamViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import ScoreReporterCore

struct TeamViewModel {
    let fullName: String?
    let competitionDivision: String?
    let location: String?
    let logoURL: URL?

    init(team: Team?) {
        fullName = [team?.school, team?.name].joined(by: " ")
        
        competitionDivision = [team?.competitionLevel, team?.division].joined(by: " ")
        
        location = [team?.city, team?.state].joined(by: ", ")
        
        logoURL = team?.searchLogoURL
    }
}
