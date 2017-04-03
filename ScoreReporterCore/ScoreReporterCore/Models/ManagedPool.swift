//
//  ManagedPool.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public class ManagedPool: NSManagedObject {

}

// MARK: - Public

public extension ManagedPool {
    static func fetchedPools(forRound round: Round) -> NSFetchedResultsController<ManagedPool> {
        let primaryKey = NSNumber(integerLiteral: round.id)
        let predicate = NSPredicate(format: "%K == %@", #keyPath(ManagedPool.round.roundID), primaryKey)

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedPool.poolID), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }

    static func fetchedPools(forGroup group: Group) -> NSFetchedResultsController<ManagedPool> {
        let primaryKey = NSNumber(integerLiteral: group.id)
        let predicate = NSPredicate(format: "%K == %@", #keyPath(ManagedPool.round.group.groupID), primaryKey)

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedPool.poolID), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }
}

// MARK: - Fetchable

extension ManagedPool: Fetchable {
    public static var primaryKey: String {
        return #keyPath(ManagedPool.poolID)
    }
}

// MARK: - CoreDataImportable

extension ManagedPool: CoreDataImportable {
    public static func object(from dictionary: [String: Any], context: NSManagedObjectContext) -> ManagedPool? {
        guard let poolID = dictionary[APIConstants.Response.Keys.poolID] as? NSNumber else {
            return nil
        }

        guard let pool = object(primaryKey: poolID, context: context, createNew: true) else {
            return nil
        }

        pool.poolID = poolID
        pool.name = dictionary <~ APIConstants.Response.Keys.name

        let games = dictionary[APIConstants.Response.Keys.games] as? [[String: AnyObject]] ?? []
        let gamesArray = ManagedGame.objects(from: games, context: context)

        for (index, game) in gamesArray.enumerated() {
            game.sortOrder = index as NSNumber
        }

        pool.games = NSSet(array: gamesArray)

        let standings = dictionary[APIConstants.Response.Keys.standings] as? [[String: AnyObject]] ?? []
        pool.standings = NSSet(array: ManagedStanding.objects(from: standings, context: context))

        if !pool.hasPersistentChangedValues {
            context.refresh(pool, mergeChanges: false)
        }

        return pool
    }
}
