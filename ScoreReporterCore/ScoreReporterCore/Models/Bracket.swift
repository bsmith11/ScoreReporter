//
//  Bracket.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public class Bracket: NSManagedObject {

}

// MARK: - Public

public extension Bracket {
    static func fetchedBracketsFor(group: Group) -> NSFetchedResultsController<Bracket> {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Bracket.round.group), group)

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Bracket.bracketID), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }
}

// MARK: - Fetchable

extension Bracket: Fetchable {
    public static var primaryKey: String {
        return #keyPath(Bracket.bracketID)
    }
}

// MARK: - CoreDataImportable

extension Bracket: CoreDataImportable {
    public static func object(from dictionary: [String: Any], context: NSManagedObjectContext) -> Bracket? {
        guard let bracketID = dictionary[APIConstants.Response.Keys.bracketID] as? NSNumber else {
            return nil
        }

        guard let bracket = object(primaryKey: bracketID, context: context, createNew: true) else {
            return nil
        }

        bracket.bracketID = bracketID
        bracket.name = dictionary <~ APIConstants.Response.Keys.bracketName

        let stages = dictionary[APIConstants.Response.Keys.stage] as? [[String: AnyObject]] ?? []
        bracket.stages = NSSet(array: Stage.objects(from: stages, context: context))

        if !bracket.hasPersistentChangedValues {
            context.refresh(bracket, mergeChanges: false)
        }

        return bracket
    }
}
