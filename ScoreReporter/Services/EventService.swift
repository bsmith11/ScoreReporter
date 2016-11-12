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
    func downloadEventListWithCompletion(_ completion: DownloadCompletion?) {
        let parameters = [
            "f": "GETALLEVENTS"
        ]
        
        let requestCompletion = { (result: Result<Any>) in
            if result.isSuccess {
                self.handleSuccessfulEventListResponse(result.value, completion: completion)
            }
            else {
                completion?(result.error as NSError?)
            }
        }
        
        client.request(.get, path: "", parameters: parameters, completion: requestCompletion)
    }

    func downloadDetailsForEvent(_ event: Event, completion: DownloadCompletion?) {
        let parameters = [
            "f": "GETGAMESBYEVENT",
            "EventId": event.eventID
        ] as [String : Any]

        let requestCompletion = { (result: Result<Any>) in
            if result.isSuccess {
                self.handleSuccessfulEventResponse(result.value, completion: completion)
            }
            else {
                completion?(result.error as NSError?)
            }
        }
        
        client.request(.get, path: "", parameters: parameters, completion: requestCompletion)
    }
}

// MARK: - Private

private extension EventService {
    func handleSuccessfulEventListResponse(_ response: Any?, completion: DownloadCompletion?) {
        guard let responseObject = response as? [String: AnyObject],
                  let eventArray = responseObject["Events"] as? [[String: AnyObject]] else {
            let error = NSError(domain: "Invalid response structure", code: 0, userInfo: nil)
            completion?(error)
            return
        }

        Event.eventsFromArray(eventArray, completion: completion)
    }

    func handleSuccessfulEventResponse(_ response: Any?, completion: DownloadCompletion?) {
        guard let responseObject = response as? [String: AnyObject] else {
            let error = NSError(domain: "Invalid response structure", code: 0, userInfo: nil)
            completion?(error)
            return
        }
        
        guard let groupArray = responseObject["EventGroups"] as? [[String: AnyObject]] else {
            if let message = responseObject["error"] as? String {
                print("Error Message: \(message)")
                completion?(nil)
            }
            else {
                let error = NSError(domain: "Invalid response structure", code: 0, userInfo: nil)
                completion?(error)
            }
            
            return
        }

        Group.groupsFromArray(groupArray, completion: completion)
    }
}
