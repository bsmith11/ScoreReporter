//
//  Pool.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

class Pool: NSManagedObject {
    
}

// MARK: - Public

extension Pool {
    static func fetchedPoolsForRound(round: Round) -> NSFetchedResultsController {
        let predicate = NSPredicate(format: "%K == %@", "round", round)
        
        let sortDescriptors = [
            NSSortDescriptor(key: "poolID", ascending: true),
        ]
        
        return fetchedResultsControllerWithPredicate(predicate, sortDescriptors: sortDescriptors)
    }
    
    static func fetchedPoolsForGroup(group: Group) -> NSFetchedResultsController {
        let predicate = NSPredicate(format: "%K == %@", "round.group", group)
        
        let sortDescriptors = [
            NSSortDescriptor(key: "poolID", ascending: true),
        ]
        
        return fetchedResultsControllerWithPredicate(predicate, sortDescriptors: sortDescriptors)
    }
}

// MARK: - Fetchable

extension Pool: Fetchable {
    static var primaryKey: String {
        return "poolID"
    }
}

// MARK: - CoreDataImportable

extension Pool: CoreDataImportable {
    static func objectFromDictionary(dictionary: [String : AnyObject], context: NSManagedObjectContext) -> Pool? {
        guard let poolID = dictionary["PoolId"] as? Int else {
            return nil
        }
        
        guard let pool = objectWithPrimaryKey(poolID, context: context, createNew: true) else {
            return nil
        }
        
        pool.poolID = poolID
        pool.name = dictionary["Name"] as? String
        
        let games = dictionary["Games"] as? [[String: AnyObject]] ?? []
        let gamesArray = Game.objectsFromArray(games, context: context)
        
        for (index, game) in gamesArray.enumerate() {
            game.sortOrder = index
        }
        
        pool.games = NSSet(array: gamesArray)
        
        let standings = dictionary["Standings"] as? [[String: AnyObject]] ?? []
        pool.standings = NSSet(array: Standing.objectsFromArray(standings, context: context))
        
        return pool
    }
}
