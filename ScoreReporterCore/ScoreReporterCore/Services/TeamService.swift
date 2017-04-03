//
//  TeamService.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

public class TeamService: APIService {

}

// MARK: - Public

public extension TeamService {
    func getTeamList(completion: ServiceCompletion?) {
        let parameters: [String: Any] = [
            APIConstants.Path.Keys.function: APIConstants.Path.Values.teams
        ]
        
        client.request(method: .get, path: "", parameters: parameters) { result in
            switch result {
            case .success(let value):
                self.parseTeamList(response: value, completion: completion)
            case .failure(let error):
                completion?(ServiceResult(error: error))
            }
        }
    }

    func getDetails(forTeam team: Team, completion: ServiceCompletion?) {
        let parameters: [String: Any] = [
            APIConstants.Path.Keys.function: APIConstants.Path.Values.teamDetails,
            APIConstants.Request.Keys.teamID: team.id
        ]

        client.request(method: .get, path: "", parameters: parameters) { result in
            switch result {
            case .success(let value):
                self.parseTeam(response: value, team: team, completion: completion)
            case .failure(let error):
                completion?(ServiceResult(error: error))
            }
        }
    }
}

// MARK: - Private

private extension TeamService {
    func parseTeamList(response: [String: Any], completion: ServiceCompletion?) {        
        guard let teamArray = response[APIConstants.Response.Keys.teams] as? [[String: AnyObject]] else {
            let error = NSError(type: .invalidResponse)
            completion?(ServiceResult(error: error))
            return
        }

        ManagedTeam.teams(from: teamArray) { error in
            completion?(ServiceResult(error: error))
        }
    }

    func parseTeam(response: [String: Any], team: Team, completion: ServiceCompletion?) {
        guard let responseArray = response[APIConstants.Response.Keys.groups] as? [[String: AnyObject]] else {
            let error = NSError(type: .invalidResponse)
            completion?(ServiceResult(error: error))
            return
        }
        
        let gameIDs = self.gameIDs(fromResponseArray: responseArray)

        let partialEventDictionaries = responseArray.flatMap { dictionary -> [String: AnyObject]? in
            guard let eventID = dictionary[APIConstants.Response.Keys.eventID] as? NSNumber else {
                return nil
            }

            var partial = [String: AnyObject]()
            partial[APIConstants.Response.Keys.eventID] = eventID
            partial[APIConstants.Response.Keys.eventName] = dictionary[APIConstants.Response.Keys.eventName]

            return partial
        }

        let eventImportOperations = partialEventDictionaries.map { EventImportOperation(eventDictionary: $0) }

        let groupEventTuples = responseArray.flatMap { dictionary -> (NSNumber, NSNumber)? in
            guard let eventID = dictionary[APIConstants.Response.Keys.eventID] as? NSNumber,
                  let groupID = dictionary[APIConstants.Response.Keys.groupID] as? NSNumber else {
                return nil
            }

            return (groupID, eventID)
        }

        let eventIDs = responseArray.flatMap { $0[APIConstants.Response.Keys.eventID] as? NSNumber }
        let eventDetailsOperations = eventIDs.map { EventDetailsOperation(eventID: $0) }

        let terminalOperation = BlockOperation {
            ManagedGroup.coreDataStack.performBlockUsingBackgroundContext({ context in
                let primaryKey = NSNumber(integerLiteral: team.id)
                if let contextualTeam = ManagedTeam.object(primaryKey: primaryKey, context: context) {
                    ManagedGame.objects(withPrimaryKeys: gameIDs, context: context).forEach { $0.add(team: contextualTeam) }
                }
                
                groupEventTuples.forEach { (groupID, eventID) in
                    let group = ManagedGroup.object(primaryKey: groupID, context: context)
                    let event = ManagedEvent.object(primaryKey: eventID, context: context)

                    group?.event = event
                }
            }, completion: { error in
                completion?(ServiceResult(error: error))
            })
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
    
    func gameIDs(fromResponseArray responseArray: [[String: AnyObject]]) -> [NSNumber] {
        var gameIDs = [NSNumber]()
        
        responseArray.forEach { group in
            if let rounds = group["EventRounds"] as? [[String: AnyObject]] {
                rounds.forEach { round in
                    if let brackets = round["Brackets"] as? [[String: AnyObject]] {
                        brackets.forEach { bracket in
                            if let stages = bracket["Stage"] as? [[String: AnyObject]] {
                                stages.forEach { stage in
                                    if let games = stage["Games"] as? [[String: AnyObject]] {
                                        games.forEach { game in
                                            if let gameID = game["EventGameId"] as? NSNumber {
                                                gameIDs.append(gameID)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    if let clusters = round["Clusters"] as? [[String: AnyObject]] {
                        clusters.forEach { cluster in
                            if let games = cluster["Games"] as? [[String: AnyObject]] {
                                games.forEach { game in
                                    if let gameID = game["EventGameId"] as? NSNumber {
                                        gameIDs.append(gameID)
                                    }
                                }
                            }
                        }
                    }
                    
                    if let pools = round["Pools"] as? [[String: AnyObject]] {
                        pools.forEach { pool in
                            if let games = pool["Games"] as? [[String: AnyObject]] {
                                games.forEach { game in
                                    if let gameID = game["EventGameId"] as? NSNumber {
                                        gameIDs.append(gameID)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return gameIDs
    }
}

class EventImportOperation: AsyncOperation {
    convenience init(eventDictionary: [String: AnyObject]) {
        let block = { (completion: @escaping AsyncOperationCompletion) in
            ManagedEvent.events(from: [eventDictionary], completion: { _ in
                print("Finished importing event")
                completion()
            })
        }

        self.init(block: block)
    }
}

class EventDetailsOperation: AsyncOperation {
    convenience init(eventID: NSNumber) {
        let block = { (completion: @escaping AsyncOperationCompletion) in
            let eventService = EventService()

            eventService.getDetailsForEvent(withId: eventID.intValue, completion: { error in
                print("Finished downloading \(eventID) with error: \(error)")

                completion()
            })
        }

        self.init(block: block)
    }
}
