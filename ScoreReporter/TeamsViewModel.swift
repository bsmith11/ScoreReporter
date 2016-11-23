//
//  TeamsViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/22/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import ScoreReporterCore

class TeamsViewModel: NSObject {
    fileprivate let teamService = TeamService(client: APIClient.sharedInstance)

    fileprivate(set) dynamic var loading = false
    fileprivate(set) dynamic var error: NSError? = nil
}

// MARK: - Public

extension TeamsViewModel {
    func downloadTeams() {
        loading = true

        teamService.downloadTeamList { [weak self] error in
            self?.loading = false
            self?.error = error
        }
    }
}
