//
//  ManagedBracket.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public class ManagedBracket: NSManagedObject {

}

// MARK: - Public

public extension ManagedBracket {
    static func fetchedBracketsForGroup(withId groupId: Int) -> NSFetchedResultsController<ManagedBracket> {
        let primaryKey = NSNumber(integerLiteral: groupId)
        let predicate = NSPredicate(format: "%K == %@", #keyPath(ManagedBracket.round.group.groupID), primaryKey)

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedBracket.bracketID), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }
}

// MARK: - Fetchable

extension ManagedBracket: Fetchable {
    public static var primaryKey: String {
        return #keyPath(ManagedBracket.bracketID)
    }
}

// MARK: - CoreDataImportable

extension ManagedBracket: CoreDataImportable {
    public static func object(from dictionary: [String: Any], context: NSManagedObjectContext) -> ManagedBracket? {
        guard let bracketID = dictionary[APIConstants.Response.Keys.bracketID] as? NSNumber else {
            return nil
        }

        guard let bracket = object(primaryKey: bracketID, context: context, createNew: true) else {
            return nil
        }

        bracket.bracketID = bracketID
        bracket.name = dictionary <~ APIConstants.Response.Keys.bracketName

        let stages = dictionary[APIConstants.Response.Keys.stage] as? [[String: AnyObject]] ?? []
        bracket.stages = NSSet(array: ManagedStage.objects(from: stages, context: context))

        if !bracket.hasPersistentChangedValues {
            context.refresh(bracket, mergeChanges: false)
        }

        return bracket
    }
}
