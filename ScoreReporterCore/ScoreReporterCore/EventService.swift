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
        let parameters: [String: Any] = [
            APIConstants.Path.Keys.function: APIConstants.Path.Values.events
        ]

        client.request(.get, path: "", parameters: parameters) { result in
            switch result {
            case .success(let value):
                self.parseEventList(response: value, completion: completion)
            case .failure(let error):
                completion?(error as NSError)
            }
        }
    }

    func downloadDetails(for eventID: NSNumber, completion: DownloadCompletion?) {
        let parameters: [String: Any] = [
            APIConstants.Path.Keys.function: APIConstants.Path.Values.eventDetails,
            APIConstants.Request.Keys.eventID: eventID
        ]

        client.request(.get, path: "", parameters: parameters) { result in
            switch result {
            case .success(let value):
                self.parseEvent(response: value, completion: completion)
            case .failure(let error):
                completion?(error as NSError)
            }
        }
    }

    func downloadDetails(for event: Event, completion: DownloadCompletion?) {
        downloadDetails(for: event.eventID, completion: completion)
    }
}

// MARK: - Private

private extension EventService {
    func parseEventList(response: [String: Any], completion: DownloadCompletion?) {
        guard let eventArray = response[APIConstants.Response.Keys.events] as? [[String: AnyObject]] else {
            let error = NSError(domain: "Invalid response structure", code: 0, userInfo: nil)
            completion?(error)
            return
        }

        Event.events(from: eventArray, completion: completion)
    }

    func parseEvent(response: [String: Any], completion: DownloadCompletion?) {
        guard let groupArray = response[APIConstants.Response.Keys.groups] as? [[String: AnyObject]] else {
            let error = NSError(domain: "Invalid response structure", code: 0, userInfo: nil)
            completion?(error)
            return
        }

        Group.groups(from: groupArray, completion: completion)
    }
}
