//
//  Game.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

class Game: NSManagedObject {
    
}

// MARK: - Public

extension Game {
    static func fetchedGamesForPool(_ pool: Pool) -> NSFetchedResultsController<NSFetchRequestResult> {
        let predicate = NSPredicate(format: "%K == %@", "pool", pool)
        
        let sortDescriptors = [
            NSSortDescriptor(key: "sortOrder", ascending: true),
            NSSortDescriptor(key: "startDateFull", ascending: true)
        ]
        
        return fetchedResultsControllerWithPredicate(predicate, sortDescriptors: sortDescriptors, sectionNameKeyPath: "startDateFull")
    }
    
    static func fetchedGamesForCluster(_ cluster: Cluster) -> NSFetchedResultsController<NSFetchRequestResult> {
        let predicate = NSPredicate(format: "%K == %@", "cluster", cluster)
        
        let sortDescriptors = [
            NSSortDescriptor(key: "sortOrder", ascending: true),
            NSSortDescriptor(key: "startDateFull", ascending: true)
        ]
        
        return fetchedResultsControllerWithPredicate(predicate, sortDescriptors: sortDescriptors, sectionNameKeyPath: "startDateFull")
    }
    
    static func fetchedActiveGamesForEvent(_ event: Event) -> NSFetchedResultsController<NSFetchRequestResult> {
        let gamePredicates = [
            NSPredicate(format: "%K == %@", "pool.round.group.event", event),
            NSPredicate(format: "%K == %@", "cluster.round.group.event", event),
            NSPredicate(format: "%K == %@", "stage.bracket.round.group.event", event)
        ]
        
        let gamePredicate = NSCompoundPredicate(orPredicateWithSubpredicates: gamePredicates)
        let activePredicate = NSPredicate(format: "%K == %@", "status", "In Progress")
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [gamePredicate, activePredicate])
        
        let sortDescriptors = [
            NSSortDescriptor(key: "sortOrder", ascending: true),
            NSSortDescriptor(key: "startDateFull", ascending: true)
        ]
        
        return fetchedResultsControllerWithPredicate(predicate, sortDescriptors: sortDescriptors)
    }
}

// MARK: - Fetchable

extension Game: Fetchable {
    static var primaryKey: String {
        return "gameID"
    }
}

// MARK: - CoreDataImportable

extension Game: CoreDataImportable {
    static func objectFromDictionary(_ dictionary: [String : AnyObject], context: NSManagedObjectContext) -> Game? {
        guard let gameID = dictionary["EventGameId"] as? NSNumber else {
            return nil
        }
        
        guard let game = objectWithPrimaryKey(gameID, context: context, createNew: true) else {
            return nil
        }
        
        game.gameID = gameID
        game.homeTeamName = dictionary["HomeTeamName"] as? String
        game.homeTeamScore = dictionary["HomeTeamScore"] as? String
        game.awayTeamName = dictionary["AwayTeamName"] as? String
        game.awayTeamScore = dictionary["AwayTeamScore"] as? String
        game.fieldName = dictionary["FieldName"] as? String
        game.status = dictionary["GameStatus"] as? String
        
        let startDate = dictionary["StartDate"] as? String
        game.startDate = startDate.flatMap { DateService.gameDateFormatter.date(from: $0) }
        
        let startTime = dictionary["StartTime"] as? String
        game.startTime = startTime.flatMap { DateService.gameTimeFormatter.date(from: $0) }
        
        game.startDateFull = Date.dateWithDate(game.startDate, time: game.startTime)
        
        return game
    }
}
