//
//  EventService.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

public typealias DownloadCompletion = (DownloadResult) -> Void

public enum DownloadResult {
    case success
    case failure(NSError)
    
    public init(error: Error?) {
        if let error = error as? NSError {
            self = .failure(error)
        }
        else {
            self = .success
        }
    }
}

public extension DownloadResult {
    var error: NSError? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

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
                completion?(DownloadResult(error: error))
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
                completion?(DownloadResult(error: error))
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
            let error = NSError(type: .invalidResponse)
            completion?(DownloadResult(error: error))
            return
        }

        Event.events(from: eventArray) { error in
            completion?(DownloadResult(error: error))
        }
    }

    func parseEvent(response: [String: Any], completion: DownloadCompletion?) {
        guard !response.isEmpty else {
            let error = NSError(type: .emptyResponse)
            completion?(DownloadResult(error: error))
            return
        }
        
        guard let groupArray = response[APIConstants.Response.Keys.groups] as? [[String: AnyObject]] else {
            let error = NSError(type: .invalidResponse)
            completion?(DownloadResult(error: error))
            return
        }

        Group.groups(from: groupArray) { error in
            completion?(DownloadResult(error: error))
        }
    }
}
