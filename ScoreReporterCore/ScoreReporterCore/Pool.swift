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
    static func fetchedPoolsForRound(_ round: Round) -> NSFetchedResultsController<NSFetchRequestResult> {
        let predicate = NSPredicate(format: "%K == %@", "round", round)
        
        let sortDescriptors = [
            NSSortDescriptor(key: "poolID", ascending: true),
        ]
        
        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }
    
    static func fetchedPoolsForGroup(_ group: Group) -> NSFetchedResultsController<NSFetchRequestResult> {
        let predicate = NSPredicate(format: "%K == %@", "round.group", group)
        
        let sortDescriptors = [
            NSSortDescriptor(key: "poolID", ascending: true),
        ]
        
        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }
}

// MARK: - Fetchable

extension Pool: Fetchable {
    public static var primaryKey: String {
        return "poolID"
    }
}

// MARK: - CoreDataImportable

extension Pool: CoreDataImportable {
    public static func object(from dictionary: [String : AnyObject], context: NSManagedObjectContext) -> Pool? {
        guard let poolID = dictionary["PoolId"] as? NSNumber else {
            return nil
        }
        
        guard let pool = object(primaryKey: poolID, context: context, createNew: true) else {
            return nil
        }
        
        pool.poolID = poolID
        pool.name = dictionary["Name"] as? String
        
        let games = dictionary["Games"] as? [[String: AnyObject]] ?? []
        let gamesArray = Game.objects(from: games, context: context)
        
        for (index, game) in gamesArray.enumerated() {
            game.sortOrder = index as NSNumber
        }
        
        pool.games = NSSet(array: gamesArray)
        
        let standings = dictionary["Standings"] as? [[String: AnyObject]] ?? []
        pool.standings = NSSet(array: Standing.objects(from: standings, context: context))
        
        return pool
    }
}
