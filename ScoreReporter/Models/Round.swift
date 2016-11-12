//
//  Round.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

enum RoundType: Int {
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

class Round: NSManagedObject {
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
}

// MARK: - Fetchable

extension Round: Fetchable {
    static var primaryKey: String {
        return "roundID"
    }
}

// MARK: - CoreDataImportable

extension Round: CoreDataImportable {
    static func objectFromDictionary(_ dictionary: [String : AnyObject], context: NSManagedObjectContext) -> Round? {
        guard let roundID = dictionary["RoundId"] as? NSNumber else {
            return nil
        }
        
        guard let round = objectWithPrimaryKey(roundID, context: context, createNew: true) else {
            return nil
        }
        
        round.roundID = roundID
        
        let brackets = dictionary["Brackets"] as? [[String: AnyObject]] ?? []
        let bracketsArray = Bracket.objectsFromArray(brackets, context: context)
        
        for (index, bracket) in bracketsArray.enumerated() {
            bracket.sortOrder = index as NSNumber
        }
        
        round.brackets = NSSet(array: bracketsArray)
        
        let clusters = dictionary["Clusters"] as? [[String: AnyObject]] ?? []
        round.clusters = NSSet(array: Cluster.objectsFromArray(clusters, context: context))
        
        let pools = dictionary["Pools"] as? [[String: AnyObject]] ?? []
        round.pools = NSSet(array: Pool.objectsFromArray(pools, context: context))
        
        return round
    }
}
