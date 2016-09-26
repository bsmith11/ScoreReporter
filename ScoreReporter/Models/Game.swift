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
    static func fetchedGamesForPool(pool: Pool) -> NSFetchedResultsController {
        let predicate = NSPredicate(format: "%K == %@", "pool", pool)
        
        let sortDescriptors = [
            NSSortDescriptor(key: "sortOrder", ascending: true),
            NSSortDescriptor(key: "startDateFull", ascending: true)
        ]
        
        let request = NSFetchRequest(entityName: rzv_entityName())
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: rzv_coreDataStack().mainManagedObjectContext, sectionNameKeyPath: "startDateFull", cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch let error as NSError {
            print("Failed to fetch games with error: \(error)")
        }
        
        return fetchedResultsController
    }
    
    static func fetchedGamesForCluster(cluster: Cluster) -> NSFetchedResultsController {
        let predicate = NSPredicate(format: "%K == %@", "cluster", cluster)
        
        let sortDescriptors = [
            NSSortDescriptor(key: "sortOrder", ascending: true),
            NSSortDescriptor(key: "startDateFull", ascending: true)
        ]
        
        let request = NSFetchRequest(entityName: rzv_entityName())
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: rzv_coreDataStack().mainManagedObjectContext, sectionNameKeyPath: "startDateFull", cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch let error as NSError {
            print("Failed to fetch games with error: \(error)")
        }
        
        return fetchedResultsController
    }
}

// MARK: - RZVinyl

extension Game {
    override class func rzv_shouldAlwaysCreateNewObjectOnImport() -> Bool {
        return true
    }
}

// MARK: - RZImport

extension Game {
    override class func rzi_customMappings() -> [String: String] {
        return [
            "HomeTeamName": "homeTeamName",
            "HomeTeamScore": "homeTeamScore",
            "AwayTeamName": "awayTeamName",
            "AwayTeamScore": "awayTeamScore",
            "GameStatus": "status",
            "FieldName": "fieldName"
        ]
    }
    
    override class func rzi_orderedKeys() -> [String] {
        return [
            "StartDate",
            "StartTime"
        ]
    }

    override func rzi_shouldImportValue(value: AnyObject, forKey key: String) -> Bool {
        switch key {
        case "StartDate":
            if let value = value as? String {
                startDate = DateService.gameDateFormatter.dateFromString(value)
            }
            else {
                startDate = nil
            }

            return false
        case "StartTime":
            if let value = value as? String {
                startTime = DateService.gameTimeFormatter.dateFromString(value)
            }
            else {
                startTime = nil
            }
            
            startDateFull = NSDate.dateWithDate(startDate, time: startTime)

            return false
        default:
            return super.rzi_shouldImportValue(value, forKey: key)
        }
    }
}
