//
//  TeamSearchViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

class TeamSearchViewModel: NSObject {
    fileprivate let teamService = TeamService(client: APIClient.sharedInstance)
    
    fileprivate(set) dynamic var loading = false
    fileprivate(set) dynamic var error: NSError? = nil
}

// MARK: - Public

extension TeamSearchViewModel {
    func downloadTeams() {
        loading = true
        
        teamService.downloadTeamListWithCompletion { [weak self] error in
            self?.loading = false
            self?.error = error
        }
    }
}
