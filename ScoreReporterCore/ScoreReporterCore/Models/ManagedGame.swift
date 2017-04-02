//
//  ManagedGame.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public class ManagedGame: NSManagedObject {

}

// MARK: - Public

public extension ManagedGame {
    var group: ManagedGroup? {
        return cluster?.round?.group ?? pool?.round?.group ?? stage?.bracket?.round?.group
    }
    
    func add(team: ManagedTeam) {
        if let name = team.name {
            if let homeTeamName = homeTeamName, homeTeamName == name {
                homeTeam = team
                return
            }
            else if let awayTeamName = awayTeamName, awayTeamName == name {
                awayTeam = team
                return
            }
        }
        
        if let school = team.school {
            if let homeTeamName = homeTeamName, homeTeamName == school {
                homeTeam = team
                return
            }
            else if let awayTeamName = awayTeamName, awayTeamName == school {
                awayTeam = team
                return
            }
        }
    }
    
    static func update(with gameUpdate: GameUpdate, completion: ImportCompletion?) {
        let block = { (context: NSManagedObjectContext) in
            guard let game = ManagedGame.object(primaryKey: gameUpdate.gameID, context: context) else {
                return
            }
            
            game.homeTeamScore = gameUpdate.homeTeamScore
            game.awayTeamScore = gameUpdate.awayTeamScore
            game.status = gameUpdate.gameStatus
        }
        
        coreDataStack.performBlockUsingBackgroundContext(block, completion: completion)
    }

    static func gamesToday(for team: ManagedTeam) -> [ManagedGame] {
        guard let games = ManagedGame.fetchedGamesFor(team: team).fetchedObjects else {
            return []
        }

        let calendar = Calendar.current
        let today = Date()
        let currentGames = games.filter { game -> Bool in
            guard let startDate = game.startDate else {
                return false
            }

            return calendar.compare(startDate, to: today, toGranularity: .day) == .orderedSame
        }

        return currentGames
    }
    
    static func fetchedBracketGamesFor(group: ManagedGroup, teamName: String) -> NSFetchedResultsController<ManagedGame> {
        let groupPredicates = NSPredicate(format: "%K == %@", #keyPath(ManagedGame.stage.bracket.round.group), group)
        
        return fetchedGamesFor(group: group, teamName: teamName, predicate: groupPredicates)
    }
    
    static func fetchedPoolGamesFor(group: ManagedGroup, teamName: String) -> NSFetchedResultsController<ManagedGame> {
        let groupPredicate = NSPredicate(format: "%K == %@", #keyPath(ManagedGame.pool.round.group), group)
        
        return fetchedGamesFor(group: group, teamName: teamName, predicate: groupPredicate)
    }
    
    static func fetchedCrossoverGamesFor(group: ManagedGroup, teamName: String) -> NSFetchedResultsController<ManagedGame> {
        let groupPredicate = NSPredicate(format: "%K == %@", #keyPath(ManagedGame.cluster.round.group), group)
        
        return fetchedGamesFor(group: group, teamName: teamName, predicate: groupPredicate)
    }
    
    static func fetchedGamesFor(group: ManagedGroup, teamName: String, predicate: NSPredicate) -> NSFetchedResultsController<ManagedGame> {
        let namePredicates = [
            NSPredicate(format: "%K == %@", #keyPath(ManagedGame.homeTeamName), teamName),
            NSPredicate(format: "%K == %@", #keyPath(ManagedGame.awayTeamName), teamName)
        ]
        
        let namePredicate = NSCompoundPredicate(orPredicateWithSubpredicates: namePredicates)
        let fullPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, namePredicate])
        
        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedGame.startDateFull), ascending: true)
        ]
        
        return fetchedResultsController(predicate: fullPredicate, sortDescriptors: sortDescriptors)
    }

    static func fetchedGamesForPool(withId poolId: Int) -> NSFetchedResultsController<ManagedGame> {
        let primaryKey = NSNumber(integerLiteral: poolId)
        let predicate = NSPredicate(format: "%K == %@", #keyPath(ManagedGame.pool.poolID), primaryKey)

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedGame.sortOrder), ascending: true),
            NSSortDescriptor(key: #keyPath(ManagedGame.startDateFull), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors, sectionNameKeyPath: #keyPath(ManagedGame.startDateFull))
    }

    static func fetchedGamesFor(clusters: [ManagedCluster]) -> NSFetchedResultsController<ManagedGame> {
        let predicate = NSPredicate(format: "%K IN %@", #keyPath(ManagedGame.cluster), clusters)

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedGame.sortOrder), ascending: true),
            NSSortDescriptor(key: #keyPath(ManagedGame.startDateFull), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors, sectionNameKeyPath: #keyPath(ManagedGame.startDateFull))
    }
    
    static func fetchedGamesForStage(withId stageId: Int) -> NSFetchedResultsController<ManagedGame> {
        let primaryKey = NSNumber(integerLiteral: stageId)
        let predicate = NSPredicate(format: "%K == %@", #keyPath(ManagedGame.stage.stageID), primaryKey)
        
        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedGame.sortOrder), ascending: true),
            NSSortDescriptor(key: #keyPath(ManagedGame.startDateFull), ascending: true)
        ]
        
        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors, sectionNameKeyPath: #keyPath(ManagedGame.startDateFull))
    }

    static func fetchedGamesFor(team: ManagedTeam) -> NSFetchedResultsController<ManagedGame> {
        let predicates = [
            NSPredicate(format: "%K == %@", #keyPath(ManagedGame.homeTeam), team),
            NSPredicate(format: "%K == %@", #keyPath(ManagedGame.awayTeam), team)
        ]
        
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        
        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedGame.startDateFull), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }

    static func fetchedActiveGamesFor(team: ManagedTeam) -> NSFetchedResultsController<ManagedGame> {
        let predicates = [
            NSPredicate(format: "%K == %@", #keyPath(ManagedGame.homeTeam), team),
            NSPredicate(format: "%K == %@", #keyPath(ManagedGame.awayTeam), team)
        ]
        
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedGame.startDateFull), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }

    static func fetchedActiveGames(forEventID eventID: Int) -> NSFetchedResultsController<ManagedGame> {
        let eventIDNumber = NSNumber(integerLiteral: eventID)
        
        let gamePredicates = [
            NSPredicate(format: "%K == %@", #keyPath(ManagedGame.pool.round.group.event.eventID), eventIDNumber),
            NSPredicate(format: "%K == %@", #keyPath(ManagedGame.cluster.round.group.event.eventID), eventIDNumber),
            NSPredicate(format: "%K == %@", #keyPath(ManagedGame.stage.bracket.round.group.event.eventID), eventIDNumber)
        ]

        let gamePredicate = NSCompoundPredicate(orPredicateWithSubpredicates: gamePredicates)
        let activePredicate = NSPredicate(format: "%K == %@", #keyPath(ManagedGame.status), APIConstants.Response.Values.inProgress)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [gamePredicate, activePredicate])

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedGame.sortOrder), ascending: true),
            NSSortDescriptor(key: #keyPath(ManagedGame.startDateFull), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }
}

// MARK: - Fetchable

extension ManagedGame: Fetchable {
    public static var primaryKey: String {
        return #keyPath(ManagedGame.gameID)
    }
}

// MARK: - CoreDataImportable

extension ManagedGame: CoreDataImportable {
    public static func object(from dictionary: [String: Any], context: NSManagedObjectContext) -> ManagedGame? {
        guard let gameID = dictionary[APIConstants.Response.Keys.gameID] as? NSNumber else {
            return nil
        }

        guard let game = object(primaryKey: gameID, context: context, createNew: true) else {
            return nil
        }

        game.gameID = gameID

        let homeValue = dictionary <~ APIConstants.Response.Keys.homeTeamName
        let homeTuple = ManagedGame.split(name: homeValue)
        game.homeTeamName = homeTuple.0
        game.homeTeamSeed = homeTuple.1
        game.homeTeamScore = dictionary <~ APIConstants.Response.Keys.homeTeamScore

        let awayValue = dictionary <~ APIConstants.Response.Keys.awayTeamName
        let awayTuple = ManagedGame.split(name: awayValue)
        game.awayTeamName = awayTuple.0
        game.awayTeamSeed = awayTuple.1
        game.awayTeamScore = dictionary <~ APIConstants.Response.Keys.awayTeamScore

        game.fieldName = dictionary <~ APIConstants.Response.Keys.fieldName
        game.status = dictionary <~ APIConstants.Response.Keys.gameStatus

        let startDate = dictionary <~ APIConstants.Response.Keys.startDate
        game.startDate = startDate.flatMap { DateFormatter.gameDateFormatter.date(from: $0) }

        let startTime = dictionary <~ APIConstants.Response.Keys.startTime
        game.startTime = startTime.flatMap { DateFormatter.gameTimeFormatter.date(from: $0) }

        game.startDateFull = Date.date(fromDate: game.startDate, time: game.startTime)

        if !game.hasPersistentChangedValues {
            context.refresh(game, mergeChanges: false)
        }

        return game
    }

    static func split(name: String?) -> (String?, String?) {
        guard let name = name else {
            return (nil, nil)
        }

        var componenets = name.components(separatedBy: " ")

        guard componenets.count > 1 else {
            return (componenets.first, nil)
        }

        let endIndex = componenets.count - 1
        let seed = componenets[endIndex]

        componenets.remove(at: endIndex)
        let seedlessName = componenets.joined(separator: " ")

        return (seedlessName, seed)
    }
}
