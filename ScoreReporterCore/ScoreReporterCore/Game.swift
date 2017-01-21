//
//  Game.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public class Game: NSManagedObject {

}

// MARK: - Public

public extension Game {
    var group: Group? {
        return cluster?.round?.group ?? pool?.round?.group ?? stage?.bracket?.round?.group
    }

    func add(team: Team) {
        if contains(team: team) {
            var mutableTeams = teams as? Set<Team> ?? []
            mutableTeams.insert(team)
            teams = NSSet(set: mutableTeams)
        }
    }

    func contains(team: Team) -> Bool {
        var isHomeTeam = false
        var isAwayTeam = false

        if let homeTeamName = homeTeamName {
            isHomeTeam = homeTeamName == team.name || homeTeamName == team.school
        }

        if let awayTeamName = awayTeamName {
            isAwayTeam = awayTeamName == team.name || awayTeamName == team.school
        }

        return isHomeTeam || isAwayTeam
    }
    
    static func update(with gameUpdate: GameUpdate, completion: ImportCompletion?) {
        let block = { (context: NSManagedObjectContext) in
            guard let game = Game.object(primaryKey: gameUpdate.gameID, context: context) else {
                return
            }
            
            game.homeTeamScore = gameUpdate.homeTeamScore
            game.awayTeamScore = gameUpdate.awayTeamScore
            game.status = gameUpdate.gameStatus
        }
        
        coreDataStack.performBlockUsingBackgroundContext(block, completion: completion)
    }

    static func gamesToday(for team: Team) -> [Game] {
        guard let games = Game.fetchedGamesFor(team: team).fetchedObjects else {
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
    
    static func fetchedBracketGamesFor(group: Group, teamName: String) -> NSFetchedResultsController<Game> {
        let groupPredicates = NSPredicate(format: "%K == %@", #keyPath(Game.stage.bracket.round.group), group)
        
        return fetchedGamesFor(group: group, teamName: teamName, predicate: groupPredicates)
    }
    
    static func fetchedPoolGamesFor(group: Group, teamName: String) -> NSFetchedResultsController<Game> {
        let groupPredicate = NSPredicate(format: "%K == %@", #keyPath(Game.pool.round.group), group)
        
        return fetchedGamesFor(group: group, teamName: teamName, predicate: groupPredicate)
    }
    
    static func fetchedCrossoverGamesFor(group: Group, teamName: String) -> NSFetchedResultsController<Game> {
        let groupPredicate = NSPredicate(format: "%K == %@", #keyPath(Game.cluster.round.group), group)
        
        return fetchedGamesFor(group: group, teamName: teamName, predicate: groupPredicate)
    }
    
    static func fetchedGamesFor(group: Group, teamName: String, predicate: NSPredicate) -> NSFetchedResultsController<Game> {
        let namePredicates = [
            NSPredicate(format: "%K == %@", #keyPath(Game.homeTeamName), teamName),
            NSPredicate(format: "%K == %@", #keyPath(Game.awayTeamName), teamName)
        ]
        
        let namePredicate = NSCompoundPredicate(orPredicateWithSubpredicates: namePredicates)
        let fullPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, namePredicate])
        
        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Game.startDateFull), ascending: true)
        ]
        
        return fetchedResultsController(predicate: fullPredicate, sortDescriptors: sortDescriptors)
    }

    static func fetchedGamesFor(pool: Pool) -> NSFetchedResultsController<Game> {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Game.pool), pool)

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Game.sortOrder), ascending: true),
            NSSortDescriptor(key: #keyPath(Game.startDateFull), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors, sectionNameKeyPath: #keyPath(Game.startDateFull))
    }

    static func fetchedGamesFor(clusters: [Cluster]) -> NSFetchedResultsController<Game> {
        let predicate = NSPredicate(format: "%K IN %@", #keyPath(Game.cluster), clusters)

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Game.sortOrder), ascending: true),
            NSSortDescriptor(key: #keyPath(Game.startDateFull), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors, sectionNameKeyPath: #keyPath(Game.startDateFull))
    }
    
    static func fetchedGamesFor(stage: Stage) -> NSFetchedResultsController<Game> {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Game.stage), stage)
        
        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Game.sortOrder), ascending: true),
            NSSortDescriptor(key: #keyPath(Game.startDateFull), ascending: true)
        ]
        
        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors, sectionNameKeyPath: #keyPath(Game.startDateFull))
    }

    static func fetchedGamesFor(team: Team) -> NSFetchedResultsController<Game> {
        let predicate = NSPredicate(format: "%@ in %K", team, #keyPath(Game.teams))

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Game.startDateFull), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }

    static func fetchedActiveGamesFor(team: Team) -> NSFetchedResultsController<Game> {
        let predicates = [
            NSPredicate(format: "%@ in %K", team, #keyPath(Game.teams))
        ]

        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Game.startDateFull), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }

    static func fetchedActiveGamesFor(event: Event) -> NSFetchedResultsController<Game> {
        let gamePredicates = [
            NSPredicate(format: "%K == %@", #keyPath(Game.pool.round.group.event), event),
            NSPredicate(format: "%K == %@", #keyPath(Game.cluster.round.group.event), event),
            NSPredicate(format: "%K == %@", #keyPath(Game.stage.bracket.round.group.event), event)
        ]

        let gamePredicate = NSCompoundPredicate(orPredicateWithSubpredicates: gamePredicates)
        let activePredicate = NSPredicate(format: "%K == %@", #keyPath(Game.status), APIConstants.Response.Values.inProgress)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [gamePredicate, activePredicate])

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Game.sortOrder), ascending: true),
            NSSortDescriptor(key: #keyPath(Game.startDateFull), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }
}

// MARK: - Fetchable

extension Game: Fetchable {
    public static var primaryKey: String {
        return #keyPath(Game.gameID)
    }
}

// MARK: - CoreDataImportable

extension Game: CoreDataImportable {
    public static func object(from dictionary: [String: Any], context: NSManagedObjectContext) -> Game? {
        guard let gameID = dictionary[APIConstants.Response.Keys.gameID] as? NSNumber else {
            return nil
        }

        guard let game = object(primaryKey: gameID, context: context, createNew: true) else {
            return nil
        }

        game.gameID = gameID

        let homeValue = dictionary <~ APIConstants.Response.Keys.homeTeamName
        let homeTuple = Game.split(name: homeValue)
        game.homeTeamName = homeTuple.0
        game.homeTeamSeed = homeTuple.1
        game.homeTeamScore = dictionary <~ APIConstants.Response.Keys.homeTeamScore

        let awayValue = dictionary <~ APIConstants.Response.Keys.awayTeamName
        let awayTuple = Game.split(name: awayValue)
        game.awayTeamName = awayTuple.0
        game.awayTeamSeed = awayTuple.1
        game.awayTeamScore = dictionary <~ APIConstants.Response.Keys.awayTeamScore

        game.fieldName = dictionary <~ APIConstants.Response.Keys.fieldName
        game.status = dictionary <~ APIConstants.Response.Keys.gameStatus

        let startDate = dictionary <~ APIConstants.Response.Keys.startDate
        game.startDate = startDate.flatMap { DateService.gameDateFormatter.date(from: $0) }

        let startTime = dictionary <~ APIConstants.Response.Keys.startTime
        game.startTime = startTime.flatMap { DateService.gameTimeFormatter.date(from: $0) }

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
