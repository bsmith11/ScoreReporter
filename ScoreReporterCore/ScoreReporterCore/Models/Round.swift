//
//  Round.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public enum RoundType: Int {
    case pools
    case clusters
    case brackets

    var title: String {
        switch self {
        case .pools:
            return "Pools"
        case .clusters:
            return "Crossovers"
        case .brackets:
            return "Bracket"
        }
    }
}

public class Round: NSManagedObject {

}

// MARK: - Public

public extension Round {
    var type: RoundType {
        if pools.count > 0 {
            return .pools
        }
        else if clusters.count > 0 {
            return .clusters
        }
        else {
            return .brackets
        }
    }
    
    static func fetchedRoundsForGroup(withId groupId: Int) -> NSFetchedResultsController<Round> {
        let primaryKey = NSNumber(integerLiteral: groupId)
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Round.group.groupID), primaryKey)
        
        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Round.roundID), ascending: true)
        ]
        
        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }
}

// MARK: - Fetchable

extension Round: Fetchable {
    public static var primaryKey: String {
        return #keyPath(Round.roundID)
    }
}

// MARK: - CoreDataImportable

extension Round: CoreDataImportable {
    public static func object(from dictionary: [String: Any], context: NSManagedObjectContext) -> Round? {
        guard let roundID = dictionary[APIConstants.Response.Keys.roundID] as? NSNumber else {
            return nil
        }

        guard let round = object(primaryKey: roundID, context: context, createNew: true) else {
            return nil
        }

        round.roundID = roundID

        let brackets = dictionary[APIConstants.Response.Keys.brackets] as? [[String: AnyObject]] ?? []
        let bracketsArray = Bracket.objects(from: brackets, context: context)

        for (index, bracket) in bracketsArray.enumerated() {
            bracket.sortOrder = index as NSNumber
        }

        round.brackets = NSSet(array: bracketsArray)

        let clusters = dictionary[APIConstants.Response.Keys.clusters] as? [[String: AnyObject]] ?? []
        round.clusters = NSSet(array: Cluster.objects(from: clusters, context: context))

        let pools = dictionary[APIConstants.Response.Keys.pools] as? [[String: AnyObject]] ?? []
        round.pools = NSSet(array: Pool.objects(from: pools, context: context))

        if !round.hasPersistentChangedValues {
            context.refresh(round, mergeChanges: false)
        }

        return round
    }
}
