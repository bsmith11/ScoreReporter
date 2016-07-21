//
//  EventService.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import Alamofire
import RZVinyl

typealias DownloadCompletion = (NSError?) -> Void

struct EventService {
    private let baseURL = NSURL(string: "http://play.usaultimate.org/ajax/api.aspx")!
    
    let client: APIClient
}

// MARK: - Public

extension EventService {
    func downloadEventListWithCompletion(completion: DownloadCompletion?) {
        let encoding = ParameterEncoding.URL
        let request = NSMutableURLRequest(URL: baseURL)
        request.HTTPMethod = Method.GET.rawValue
        let parameters = [
            "f": "GETALLEVENTS"
        ]
        let result = encoding.encode(request, parameters: parameters)

        guard result.1 == nil else {
            completion?(result.1)
            return
        }

        client.request(result.0) { (result: Result<AnyObject, NSError>) in
            if result.isSuccess {
                self.handleSuccessfulEventListResponse(result.value, completion: completion)
            }
            else {
                completion?(result.error)
            }
        }
    }

    func downloadEventWithEventID(eventID: NSNumber, completion: DownloadCompletion?) {
        let encoding = ParameterEncoding.URL
        let request = NSMutableURLRequest(URL: baseURL)
        request.HTTPMethod = Method.GET.rawValue
        let parameters = [
            "f": "GETGAMESBYEVENT",
            "EventId": eventID
        ]
        let result = encoding.encode(request, parameters: parameters)

        guard result.1 == nil else {
            completion?(result.1)
            return
        }

        client.request(result.0) { (result: Result<AnyObject, NSError>) in
            if result.isSuccess {
                self.handleSuccessfulEventResponse(result.value, completion: completion)
            }
            else {
                completion?(result.error)
            }
        }
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

        let block = { (context: NSManagedObjectContext) -> Void in
            Event.rzi_objectsFromArray(eventArray, inContext: context)
        }

        CoreDataStack.defaultStack().performBlockUsingBackgroundContext(block, completion: completion)
    }

    func handleSuccessfulEventResponse(response: AnyObject?, completion: DownloadCompletion?) {
        guard let responseObject = response as? [String: AnyObject],
            groupArray = responseObject["EventGroups"] as? [[String: AnyObject]] else {
                let error = NSError(domain: "Invalid response structure", code: 0, userInfo: nil)
                completion?(error)
                return
        }

        let block = { (context: NSManagedObjectContext) -> Void in
            Group.rzi_objectsFromArray(groupArray, inContext: context)
        }

        CoreDataStack.defaultStack().performBlockUsingBackgroundContext(block, completion: completion)
    }
}
