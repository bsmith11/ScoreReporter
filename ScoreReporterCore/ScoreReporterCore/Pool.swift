//
//  Pool.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public class Pool: NSManagedObject {

}

// MARK: - Public

public extension Pool {
    static func fetchedPoolsForRound(_ round: Round) -> NSFetchedResultsController<Pool> {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Pool.round), round)

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Pool.poolID), ascending: true),
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }

    static func fetchedPoolsForGroup(_ group: Group) -> NSFetchedResultsController<Pool> {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Pool.round.group), group)

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Pool.poolID), ascending: true),
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }

    func add(team: Team) {
        guard let games = games.allObjects as? [Game] else {
            return
        }

        games.forEach { $0.add(team: team) }
    }
}

// MARK: - Fetchable

extension Pool: Fetchable {
    public static var primaryKey: String {
        return #keyPath(Pool.poolID)
    }
}

// MARK: - CoreDataImportable

extension Pool: CoreDataImportable {
    public static func object(from dictionary: [String : AnyObject], context: NSManagedObjectContext) -> Pool? {
        guard let poolID = dictionary[APIConstants.Response.Keys.poolID] as? NSNumber else {
            return nil
        }

        guard let pool = object(primaryKey: poolID, context: context, createNew: true) else {
            return nil
        }

        pool.poolID = poolID
        pool.name = dictionary <~ APIConstants.Response.Keys.name

        let games = dictionary[APIConstants.Response.Keys.games] as? [[String: AnyObject]] ?? []
        let gamesArray = Game.objects(from: games, context: context)

        for (index, game) in gamesArray.enumerated() {
            game.sortOrder = index as NSNumber
        }

        pool.games = NSSet(array: gamesArray)

        let standings = dictionary[APIConstants.Response.Keys.standings] as? [[String: AnyObject]] ?? []
        pool.standings = NSSet(array: Standing.objects(from: standings, context: context))

        if !pool.hasPersistentChangedValues {
            context.refresh(pool, mergeChanges: false)
        }

        return pool
    }
}
