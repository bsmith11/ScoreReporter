//
//  TeamDetailsDataController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/16/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import ScoreReporterCore

class TeamDetailsDataController: NSObject {
    fileprivate let dataSource: TeamDetailsDataSource
    fileprivate let teamService = TeamService()

    fileprivate(set) dynamic var loading = false
    fileprivate(set) dynamic var error: NSError?

    init(dataSource: TeamDetailsDataSource) {
        self.dataSource = dataSource

        super.init()
    }
}

// MARK: - Public

extension TeamDetailsDataController {
    func getTeamDetails(completion: ServiceCompletion?) {
        loading = true

        teamService.getDetails(forTeam: dataSource.team) { [weak self] result in
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
