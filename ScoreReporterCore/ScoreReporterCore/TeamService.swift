//
//  TeamService.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import Alamofire

public struct TeamService {
    fileprivate let client: APIClient
    
    public init(client: APIClient) {
        self.client = client
    }
}

// MARK: - Public

public extension TeamService {
    func downloadTeamList(completion: DownloadCompletion?) {
        let parameters = [
            "f": "GetTeams"
        ]
        
        let requestCompletion = { (result: Result<Any>) in
            if result.isSuccess {
                self.handleSuccessfulTeamListResponse(result.value, completion: completion)
            }
            else {
                completion?(result.error as NSError?)
            }
        }
        
        client.request(.get, path: "", parameters: parameters, completion: requestCompletion)
    }
    
    func downloadDetails(for team: Team, completion: DownloadCompletion?) {
        let parameters = [
            "f": "GetGamesByTeam",
            "TeamId": team.teamID.intValue
        ] as [String : Any]
        
        let requestCompletion = { (result: Result<Any>) in
            if result.isSuccess {
                self.handleSuccessfulTeamResponse(result.value, team: team, completion: completion)
            }
            else {
                completion?(result.error as NSError?)
            }
        }
        
        client.request(.get, path: "", parameters: parameters, completion: requestCompletion)
    }
}

// MARK: - Private

private extension TeamService {
    func handleSuccessfulTeamListResponse(_ response: Any?, completion: DownloadCompletion?) {
        guard let responseObject = response as? [String: AnyObject],
                  let teamArray = responseObject["Teams"] as? [[String: AnyObject]] else {
            let error = NSError(domain: "Invalid response structure", code: 0, userInfo: nil)
            completion?(error)
            return
        }
        
        Team.teams(from: teamArray, completion: completion)
    }
    
    func handleSuccessfulTeamResponse(_ response: Any?, team: Team, completion: DownloadCompletion?) {
        guard let responseObject = response as? [String: AnyObject],
              let responseArray = responseObject["EventGroups"] as? [[String: AnyObject]] else {
            let error = NSError(domain: "Invalid response structure", code: 0, userInfo: nil)
            completion?(error)
            return
        }
        
        let partialEventDictionaries = responseArray.flatMap { dictionary -> [String: AnyObject]? in
            guard let eventID = dictionary["EventId"] as? NSNumber else {
                return nil
            }
            
            var partial = [String: AnyObject]()
            partial["EventId"] = eventID
            partial["EventName"] = dictionary["EventName"]
            
            return partial
        }
        
        let eventImportOperations = partialEventDictionaries.map { EventImportOperation(eventDictionary: $0) }
        
        let groupEventTuples = responseArray.flatMap { dictionary -> (NSNumber, NSNumber)? in
            guard let eventID = dictionary["EventId"] as? NSNumber,
                  let groupID = dictionary["EventGroupId"] as? NSNumber else {
                return nil
            }
            
            return (groupID, eventID)
        }
        
        let eventIDs = responseArray.flatMap { $0["EventId"] as? NSNumber }
        let eventDetailsOperations = eventIDs.map { EventDetailsOperation(eventID: $0) }
        
        let terminalOperation = BlockOperation {
            Group.coreDataStack.performBlockUsingBackgroundContext({ context in
                if let contextualTeam = context.object(with: team.objectID) as? Team {
                    groupEventTuples.forEach { (groupID, eventID) in
                        let group = Group.object(primaryKey: groupID, context: context)
                        let event = Event.object(primaryKey: eventID, context: context)
                        
                        group?.add(team: contextualTeam)
                        group?.event = event
                    }
                }
            }, completion: completion)
        }
        
        eventImportOperations.forEach { operation in
            eventDetailsOperations.forEach { $0.addDependency(operation) }
        }
        eventDetailsOperations.forEach { terminalOperation.addDependency($0) }
        
        let queue = OperationQueue()
        queue.addOperations(eventImportOperations, waitUntilFinished: false)
        queue.addOperations(eventDetailsOperations, waitUntilFinished: false)
        queue.addOperation(terminalOperation)
    }
}

class EventImportOperation: AsyncOperation {
    convenience init(eventDictionary: [String: AnyObject]) {
        let block = { (completionHandler: @escaping AsyncOperationCompletionHandler) in
            Event.events(from: [eventDictionary], completion: { _ in
                print("Finished importing event")
                completionHandler()
            })
        }
        
        self.init(block: block)
    }
}

class EventDetailsOperation: AsyncOperation {
    convenience init(eventID: NSNumber) {
        let block = { (completionHandler: @escaping AsyncOperationCompletionHandler) in
            let eventService = EventService(client: APIClient.sharedInstance)
            
            eventService.downloadDetails(for: eventID, completion: { error in
                print("Finished downloading \(eventID) with error: \(error)")
                
                completionHandler()
            })
        }
        
        self.init(block: block)
    }
}
