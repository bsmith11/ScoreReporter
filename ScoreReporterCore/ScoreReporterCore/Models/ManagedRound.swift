//
//  ManagedRound.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public class ManagedRound: NSManagedObject {

}

// MARK: - Public

public extension ManagedRound {
    static func fetchedRounds(forGroup group: Group) -> NSFetchedResultsController<ManagedRound> {
        let primaryKey = NSNumber(integerLiteral: group.id)
        let predicate = NSPredicate(format: "%K == %@", #keyPath(ManagedRound.group.groupID), primaryKey)
        
        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedRound.roundID), ascending: true)
        ]
        
        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }
}

// MARK: - Fetchable

extension ManagedRound: Fetchable {
    public static var primaryKey: String {
        return #keyPath(ManagedRound.roundID)
    }
}

// MARK: - CoreDataImportable

extension ManagedRound: CoreDataImportable {
    public static func object(from dictionary: [String: Any], context: NSManagedObjectContext) -> ManagedRound? {
        guard let roundID = dictionary[APIConstants.Response.Keys.roundID] as? NSNumber else {
            return nil
        }

        guard let round = object(primaryKey: roundID, context: context, createNew: true) else {
            return nil
        }

        round.roundID = roundID

        let brackets = dictionary[APIConstants.Response.Keys.brackets] as? [[String: AnyObject]] ?? []
        let bracketsArray = ManagedBracket.objects(from: brackets, context: context)

        for (index, bracket) in bracketsArray.enumerated() {
            bracket.sortOrder = index as NSNumber
        }

        round.brackets = NSSet(array: bracketsArray)

        let clusters = dictionary[APIConstants.Response.Keys.clusters] as? [[String: AnyObject]] ?? []
        round.clusters = NSSet(array: ManagedCluster.objects(from: clusters, context: context))

        let pools = dictionary[APIConstants.Response.Keys.pools] as? [[String: AnyObject]] ?? []
        round.pools = NSSet(array: ManagedPool.objects(from: pools, context: context))

        if !round.hasPersistentChangedValues {
            context.refresh(round, mergeChanges: false)
        }

        return round
    }
}