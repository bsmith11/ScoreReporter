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
    static func fetchedPoolsForRound(round: Round) -> NSFetchedResultsController {
        let predicate = NSPredicate(format: "%K == %@", "round", round)
        
        let sortDescriptors = [
            NSSortDescriptor(key: "poolID", ascending: true),
        ]
        
        let request = NSFetchRequest(entityName: rzv_entityName())
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: rzv_coreDataStack().mainManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch let error as NSError {
            print("Failed to fetch pools with error: \(error)")
        }
        
        return fetchedResultsController
    }
}

// MARK: - RZVinyl

extension Pool {
    override class func rzv_externalPrimaryKey() -> String {
        return "PoolId"
    }

    override class func rzv_primaryKey() -> String {
        return "poolID"
    }
}

// MARK: - RZImport

extension Pool {
    override class func rzi_customMappings() -> [String: String] {
        return [
            "PoolId": "poolID",
            "Name": "name"
        ]
    }

    override func rzi_shouldImportValue(value: AnyObject, forKey key: String) -> Bool {
        switch key {
        case "Games":
            if let value = value as? [[String: AnyObject]],
                gamesArray = Game.rzi_objectsFromArray(value, inContext: managedObjectContext!) as? [Game] {
                gamesArray.forEach({$0.startDateFull = NSDate.dateWithDate($0.startDate, time: $0.startTime)})

                games = NSSet(array: gamesArray)
            }
            else {
                games = NSSet()
            }

            return false
        case "Standings":
            if let value = value as? [[String: AnyObject]] {
                standings = NSSet(array: Standing.rzi_objectsFromArray(value, inContext: managedObjectContext!))
            }
            else {
                standings = NSSet()
            }

            return false
        default:
            return super.rzi_shouldImportValue(value, forKey: key)
        }
    }
}
