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
    fileprivate(set) dynamic var error: NSError? = nil
    
    init(team: Team) {
        self.team = team
        
        super.init()
    }
}

// MARK: - Public

extension TeamDetailsViewModel {
    func downloadTeamDetails(completion: DownloadCompletion?) {
        loading = true
        
        teamService.downloadDetails(for: team) { [weak self] error in
            self?.loading = false
            self?.error = error
            
            completion?(error)
        }
    }
}
