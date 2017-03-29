//
//  TodayViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import ScoreReporterCore

struct TodayViewModel {
    fileprivate let teamService = TeamService()
}

// MARK: - Public

extension TodayViewModel {
    func downloadGames(completion: ServiceCompletion?) {
//        teamService.downloadDetails(for: nil, completion: completion)
    }
}
