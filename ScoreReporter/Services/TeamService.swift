//
//  TeamService.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import Alamofire

struct TeamService {
    let client: APIClient
}

// MARK: - Public

extension TeamService {
    func downloadTeamListWithCompletion(completion: DownloadCompletion?) {
        let parameters = [
            "f": "GetTeams"
        ]
        
        let requestCompletion = { (result: Result<AnyObject, NSError>) in
            if result.isSuccess {
                self.handleSuccessfulTeamListResponse(result.value, completion: completion)
            }
            else {
                completion?(result.error)
            }
        }
        
        client.request(.GET, path: "", encoding: .URL, parameters: parameters, completion: requestCompletion)
    }
}

// MARK: - Private

private extension TeamService {
    func handleSuccessfulTeamListResponse(response: AnyObject?, completion: DownloadCompletion?) {
        guard let responseObject = response as? [String: AnyObject],
                  teamArray = responseObject["Teams"] as? [[String: AnyObject]] else {
            let error = NSError(domain: "Invalid response structure", code: 0, userInfo: nil)
            completion?(error)
            return
        }
        
        Team.teamsFromArray(teamArray, completion: completion)
    }
}
