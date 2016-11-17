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
        
        let groupIDs = responseArray.flatMap { $0["EventGroupId"] as? NSNumber }
        let eventIDs = responseArray.flatMap { $0["EventId"] as? NSNumber }
        let operations = eventIDs.map { EventDetailsOperation(eventID: $0) }
        let terminalOperation = BlockOperation {
            Group.coreDataStack.performBlockUsingBackgroundContext({ context in
                if let contextualTeam = context.object(with: team.objectID) as? Team {
                    groupIDs.forEach { groupID in
                        let group = Group.object(primaryKey: groupID, context: context)
                        group?.addTeam(team: contextualTeam)
                    }
                }
            }, completion: completion)
        }
        
        operations.forEach { terminalOperation.addDependency($0) }
        
        let queue = OperationQueue()
        queue.addOperations(operations, waitUntilFinished: false)
        queue.addOperation(terminalOperation)
    }
}

class EventDetailsOperation: Operation {
    private let eventID: NSNumber
    
    convenience init(event: Event) {
        self.init(eventID: event.eventID)
    }
    
    init(eventID: NSNumber) {
        self.eventID = eventID
        
        super.init()
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    override func start() {
        _executing = true
        execute()
    }
    
    func execute() {
        let eventService = EventService(client: APIClient.sharedInstance)
        eventService.downloadDetails(for: eventID, completion: { error in
            print("Finished downloading \(self.eventID) with error: \(error)")
            
            self.finish()
        })
    }
    
    func finish() {        
        _executing = false
        _finished = true
    }
}
