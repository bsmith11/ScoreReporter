//
//  Standing.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

class Standing: NSManagedObject {
    static func fetchedStandingsForPool(pool: Pool) -> NSFetchedResultsController {
        let predicate = NSPredicate(format: "%K == %@", "pool", pool)
        
        let sortDescriptors = [
            NSSortDescriptor(key: "sortOrder", ascending: true),
        ]
        
        let request = NSFetchRequest(entityName: rzv_entityName())
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: rzv_coreDataStack().mainManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch let error as NSError {
            print("Failed to fetch standings with error: \(error)")
        }
        
        return fetchedResultsController
    }
}

// MARK: - RZVinyl

extension Standing {
    override class func rzv_shouldAlwaysCreateNewObjectOnImport() -> Bool {
        return true
    }
}

// MARK: - RZImport

extension Standing {
    override class func rzi_customMappings() -> [String: String] {
        return [
            "TeamName": "teamName",
            "Wins": "wins",
            "Losses": "losses",
            "SortOrder": "sortOrder"
        ]
    }

    override static func rzi_ignoredKeys() -> [String] {
        return [
            "Points",
            "TieBreaker",
            "GoalsFor",
            "GoalDifferential",
            "Ties",
            "GoalsAgainst"
        ]
    }

    override func rzi_shouldImportValue(value: AnyObject, forKey key: String) -> Bool {
        switch key {
        case "TeamName":
            if var value = value as? String {
                let pattern = "([0-9]+)"

                if let seedValue = value.stringMatchingRegexPattern(pattern) where !seedValue.isEmpty {
                    seed = Int(seedValue)
                }
                else {
                    seed = 0
                }
                
                if let range = seed.flatMap({value.rangeOfString("(\($0))")}) {
                    value.removeRange(range)
                }
                
                teamName = value.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            }
            else {
                seed = 0
                teamName = nil
            }
            
            return false
        default:
            return super.rzi_shouldImportValue(value, forKey: key)
        }
    }
}
