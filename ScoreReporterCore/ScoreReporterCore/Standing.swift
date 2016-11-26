//
//  Standing.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public class Standing: NSManagedObject {

}

// MARK: - Public

public extension Standing {
    static func fetchedStandingsFor(pool: Pool) -> NSFetchedResultsController<Standing> {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Standing.pool), pool)

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Standing.sortOrder), ascending: true),
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }
}

// MARK: - Fetchable

extension Standing: Fetchable {
    public static var primaryKey: String {
        return ""
    }
}

// MARK: - CoreDataImportable

extension Standing: CoreDataImportable {
    public static func object(from dictionary: [String: Any], context: NSManagedObjectContext) -> Standing? {
        guard let standing = createObject(in: context) else {
            return nil
        }

        standing.wins = dictionary[APIConstants.Response.Keys.wins] as? NSNumber
        standing.losses = dictionary[APIConstants.Response.Keys.losses] as? NSNumber
        standing.sortOrder = dictionary[APIConstants.Response.Keys.sortOrder] as? NSNumber

        let teamName = dictionary <~ APIConstants.Response.Keys.teamName
        let seed = self.seed(from: teamName)
        standing.seed = seed as NSNumber

        let seedString = "(\(seed))"
        standing.teamName = teamName?.replacingOccurrences(of: seedString, with: "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if !standing.hasPersistentChangedValues {
            context.refresh(standing, mergeChanges: false)
        }

        return standing
    }

    static func seed(from teamName: String?) -> Int {
        let pattern = "([0-9]+)"

        if let seed = teamName?.matching(regexPattern: pattern), !seed.isEmpty {
            return Int(seed) ?? 0
        }
        else {
            return 0
        }
    }
}
