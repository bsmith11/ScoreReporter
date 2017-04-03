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

    static func gamesToday(forTeam team: Team) -> [Game] {
        guard let managedGames = ManagedGame.fetchedGames(forTeam: team).fetchedObjects else {
            return []
        }
        
        let calendar = Calendar.current
        let today = Date()
        let games = managedGames.flatMap { Game(game: $0) }.filter { game -> Bool in
            guard let startDate = game.startDate else {
                return false
            }

            return calendar.compare(startDate, to: today, toGranularity: .day) == .orderedSame
        }

        return games
    }
    
    static func fetchedBracketGames(forGroup group: Group, teamName: String) -> NSFetchedResultsController<ManagedGame> {
        let primaryKey = NSNumber(integerLiteral: group.id)
        let groupPredicates = NSPredicate(format: "%K == %@", #keyPath(ManagedGame.stage.bracket.round.group.groupID), primaryKey)
        
        return fetchedGames(withTeamName: teamName, predicate: groupPredicates)
    }
    
    static func fetchedPoolGames(forGroup group: Group, teamName: String) -> NSFetchedResultsController<ManagedGame> {
        let primaryKey = NSNumber(integerLiteral: group.id)
        let groupPredicate = NSPredicate(format: "%K == %@", #keyPath(ManagedGame.pool.round.group.groupID), primaryKey)
        
        return fetchedGames(withTeamName: teamName, predicate: groupPredicate)
    }
    
    static func fetchedCrossoverGames(forGroup group: Group, teamName: String) -> NSFetchedResultsController<ManagedGame> {
        let primaryKey = NSNumber(integerLiteral: group.id)
        let groupPredicate = NSPredicate(format: "%K == %@", #keyPath(ManagedGame.cluster.round.group.groupID), primaryKey)
        
        return fetchedGames(withTeamName: teamName, predicate: groupPredicate)
    }
    
    static func fetchedGames(withTeamName teamName: String, predicate: NSPredicate) -> NSFetchedResultsController<ManagedGame> {
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

    static func fetchedGames(forPool pool: Pool) -> NSFetchedResultsController<ManagedGame> {
        let primaryKey = NSNumber(integerLiteral: pool.id)
        let predicate = NSPredicate(format: "%K == %@", #keyPath(ManagedGame.pool.poolID), primaryKey)

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedGame.sortOrder), ascending: true),
            NSSortDescriptor(key: #keyPath(ManagedGame.startDateFull), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors, sectionNameKeyPath: #keyPath(ManagedGame.startDateFull))
    }

    static func fetchedGames(forClusters clusters: [Cluster]) -> NSFetchedResultsController<ManagedGame> {
        let primaryKeys = clusters.map { NSNumber(integerLiteral: $0.id) }
        let predicate = NSPredicate(format: "%K IN %@", #keyPath(ManagedGame.cluster.clusterID), primaryKeys)

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedGame.sortOrder), ascending: true),
            NSSortDescriptor(key: #keyPath(ManagedGame.startDateFull), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors, sectionNameKeyPath: #keyPath(ManagedGame.startDateFull))
    }
    
    static func fetchedGames(forStage stage: Stage) -> NSFetchedResultsController<ManagedGame> {
        let primaryKey = NSNumber(integerLiteral: stage.id)
        let predicate = NSPredicate(format: "%K == %@", #keyPath(ManagedGame.stage.stageID), primaryKey)
        
        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedGame.sortOrder), ascending: true),
            NSSortDescriptor(key: #keyPath(ManagedGame.startDateFull), ascending: true)
        ]
        
        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors, sectionNameKeyPath: #keyPath(ManagedGame.startDateFull))
    }

    static func fetchedGames(forTeam team: Team) -> NSFetchedResultsController<ManagedGame> {
        let primaryKey = NSNumber(integerLiteral: team.id)
        let predicates = [
            NSPredicate(format: "%K == %@", #keyPath(ManagedGame.homeTeam.teamID), primaryKey),
            NSPredicate(format: "%K == %@", #keyPath(ManagedGame.awayTeam.teamID), primaryKey)
        ]
        
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        
        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedGame.startDateFull), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }

    static func fetchedActiveGames(forTeam team: Team) -> NSFetchedResultsController<ManagedGame> {
        let primaryKey = NSNumber(integerLiteral: team.id)
        let predicates = [
            NSPredicate(format: "%K == %@", #keyPath(ManagedGame.homeTeam.teamID), primaryKey),
            NSPredicate(format: "%K == %@", #keyPath(ManagedGame.awayTeam.teamID), primaryKey)
        ]
        
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedGame.startDateFull), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }

    static func fetchedActiveGames(forEvent event: Event) -> NSFetchedResultsController<ManagedGame> {
        let primaryKey = NSNumber(integerLiteral: event.id)
        let gamePredicates = [
            NSPredicate(format: "%K == %@", #keyPath(ManagedGame.pool.round.group.event.eventID), primaryKey),
            NSPredicate(format: "%K == %@", #keyPath(ManagedGame.cluster.round.group.event.eventID), primaryKey),
            NSPredicate(format: "%K == %@", #keyPath(ManagedGame.stage.bracket.round.group.event.eventID), primaryKey)
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
