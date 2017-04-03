//
//  TeamListDataController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/22/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import ScoreReporterCore

class TeamListDataController: NSObject {
    fileprivate let dataSource: TeamListDataSource
    fileprivate let teamService = TeamService()

    fileprivate(set) dynamic var loading = false
    fileprivate(set) dynamic var error: NSError? = nil
    
    init(dataSource: TeamListDataSource) {
        self.dataSource = dataSource
    }
}

// MARK: - Public

extension TeamListDataController {
    func getTeams() {
        loading = true

        teamService.getTeamList { [weak self] result in
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
        }
    }
}
