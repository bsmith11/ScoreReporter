//
//  TeamDetailsViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/16/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import ScoreReporterCore

class TeamDetailsViewModel: NSObject {
    fileprivate let team: Team
    fileprivate let teamService = TeamService(client: APIClient.sharedInstance)

    fileprivate(set) dynamic var loading = false
    fileprivate(set) dynamic var error: NSError?

    init(team: Team) {
        self.team = team

        super.init()
    }
}

// MARK: - Public

extension TeamDetailsViewModel {
    func downloadTeamDetails(completion: ServiceCompletion?) {
        loading = true

        teamService.downloadDetails(for: team) { [weak self] result in
            guard let sself = self else {
                return
            }
            
            sself.loading = false
            
            switch result {
            case .success:
                break
            case .failure(let error):
                sself.error = error
            }
            
            completion?(result)
        }
    }
}
