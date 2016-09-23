//
//  EventService.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import Alamofire

typealias DownloadCompletion = (NSError?) -> Void

struct EventService {    
    let client: APIClient
}

// MARK: - Public

extension EventService {
    func downloadEventListWithCompletion(completion: DownloadCompletion?) {
        let parameters = [
            "f": "GETALLEVENTS"
        ]
        
        let requestCompletion = { (result: Result<AnyObject, NSError>) in
            if result.isSuccess {
                self.handleSuccessfulEventListResponse(result.value, completion: completion)
            }
            else {
                completion?(result.error)
            }
        }
        
        client.request(.GET, path: "", encoding: .URL, parameters: parameters, completion: requestCompletion)
    }

    func downloadDetailsForEvent(event: Event, completion: DownloadCompletion?) {
        let parameters = [
            "f": "GETGAMESBYEVENT",
            "EventId": event.eventID
        ]

        let requestCompletion = { (result: Result<AnyObject, NSError>) in
            if result.isSuccess {
                self.handleSuccessfulEventResponse(result.value, completion: completion)
            }
            else {
                completion?(result.error)
            }
        }
        
        client.request(.GET, path: "", encoding: .URL, parameters: parameters, completion: requestCompletion)
    }
}

// MARK: - Private

private extension EventService {
    func handleSuccessfulEventListResponse(response: AnyObject?, completion: DownloadCompletion?) {
        guard let responseObject = response as? [String: AnyObject],
            eventArray = responseObject["Events"] as? [[String: AnyObject]] else {
                let error = NSError(domain: "Invalid response structure", code: 0, userInfo: nil)
                completion?(error)
                return
        }

        Event.eventsFromArrayWithCompletion(eventArray, completion: completion)
    }

    func handleSuccessfulEventResponse(response: AnyObject?, completion: DownloadCompletion?) {
        guard let responseObject = response as? [String: AnyObject],
            groupArray = responseObject["EventGroups"] as? [[String: AnyObject]] else {
                let error = NSError(domain: "Invalid response structure", code: 0, userInfo: nil)
                completion?(error)
                return
        }

        Group.groupsFromArrayWithCompletion(groupArray, completion: completion)
    }
}
