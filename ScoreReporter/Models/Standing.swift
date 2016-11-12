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
    
}

// MARK: - Public

extension Standing {
    static func fetchedStandingsForPool(_ pool: Pool) -> NSFetchedResultsController<NSFetchRequestResult> {
        let predicate = NSPredicate(format: "%K == %@", "pool", pool)
        
        let sortDescriptors = [
            NSSortDescriptor(key: "sortOrder", ascending: true),
        ]
        
        return fetchedResultsControllerWithPredicate(predicate, sortDescriptors: sortDescriptors)
    }
}

// MARK: - Fetchable

extension Standing: Fetchable {
    static var primaryKey: String {
        return ""
    }
}

// MARK: - CoreDataImportable

extension Standing: CoreDataImportable {
    static func objectFromDictionary(_ dictionary: [String : AnyObject], context: NSManagedObjectContext) -> Standing? {
        guard let standing = createObjectInContext(context) else {
            return nil
        }

        standing.wins = dictionary["Wins"] as? NSNumber
        standing.losses = dictionary["Losses"] as? NSNumber
        standing.sortOrder = dictionary["SortOrder"] as? NSNumber
        
        let teamName = dictionary["TeamName"] as? String
        let seed = seedFromTeamName(teamName)
        standing.seed = seed as NSNumber
        
        let seedString = "(\(seed))"
        standing.teamName = teamName?.replacingOccurrences(of: seedString, with: "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        return standing
    }
    
    static func seedFromTeamName(_ teamName: String?) -> Int {
        let pattern = "([0-9]+)"
        
        if let seed = teamName?.stringMatchingRegexPattern(pattern), !seed.isEmpty {
            return Int(seed) ?? 0
        }
        else {
            return 0
        }
    }
}
