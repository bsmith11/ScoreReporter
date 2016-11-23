//
//  EventService.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import Alamofire

public typealias DownloadCompletion = (NSError?) -> Void

public struct EventService {
    fileprivate let client: APIClient

    public init(client: APIClient) {
        self.client = client
    }
}

// MARK: - Public

public extension EventService {
    func downloadEventList(completion: DownloadCompletion?) {
        let parameters = [
            APIConstants.Path.Keys.function: APIConstants.Path.Values.events
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

    func downloadDetails(for eventID: NSNumber, completion: DownloadCompletion?) {
        let parameters: [String: Any] = [
            APIConstants.Path.Keys.function: APIConstants.Path.Values.eventDetails,
            APIConstants.Request.Keys.eventID: eventID
        ]

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

    func downloadDetails(for event: Event, completion: DownloadCompletion?) {
        downloadDetails(for: event.eventID, completion: completion)
    }
}

// MARK: - Private

private extension EventService {
    func handleSuccessfulEventListResponse(_ response: Any?, completion: DownloadCompletion?) {
        guard let responseObject = response as? [String: AnyObject],
                  let eventArray = responseObject[APIConstants.Response.Keys.events] as? [[String: AnyObject]] else {
            let error = NSError(domain: "Invalid response structure", code: 0, userInfo: nil)
            completion?(error)
            return
        }

        Event.events(from: eventArray, completion: completion)
    }

    func handleSuccessfulEventResponse(_ response: Any?, eventDictionary: [String: AnyObject]? = nil, completion: DownloadCompletion?) {
        guard let responseObject = response as? [String: AnyObject] else {
            let error = NSError(domain: "Invalid response structure", code: 0, userInfo: nil)
            completion?(error)
            return
        }

        guard let groupArray = responseObject[APIConstants.Response.Keys.groups] as? [[String: AnyObject]] else {
            if let message = responseObject[APIConstants.Response.Keys.error] as? String {
                print("Error Message: \(message)")
                completion?(nil)
            }
            else {
                let error = NSError(domain: "Invalid response structure", code: 0, userInfo: nil)
                completion?(error)
            }

            return
        }

        Group.groups(from: groupArray, completion: completion)
    }
}
