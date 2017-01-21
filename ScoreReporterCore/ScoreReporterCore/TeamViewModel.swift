//
//  TeamViewModel.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 1/19/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation
import ScoreReporterCore

public struct TeamViewModel {
    public let fullName: String?
    public let competitionDivision: String?
    public let location: String?
    public let logoURL: URL?
    
    public init(team: Team?) {
        fullName = [team?.school, team?.name].joined(by: " ")
        
        competitionDivision = [team?.competitionLevel, team?.division].joined(by: " ")
        
        location = [team?.city, team?.state].joined(by: ", ")
        
        logoURL = team?.searchLogoURL
    }
}
