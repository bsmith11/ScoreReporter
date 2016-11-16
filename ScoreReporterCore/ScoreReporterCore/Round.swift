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
}

// MARK: - Fetchable

extension Round: Fetchable {
    public static var primaryKey: String {
        return "roundID"
    }
}

// MARK: - CoreDataImportable

extension Round: CoreDataImportable {
    public static func object(from dictionary: [String : AnyObject], context: NSManagedObjectContext) -> Round? {
        guard let roundID = dictionary["RoundId"] as? NSNumber else {
            return nil
        }
        
        guard let round = object(primaryKey: roundID, context: context, createNew: true) else {
            return nil
        }
        
        round.roundID = roundID
        
        let brackets = dictionary["Brackets"] as? [[String: AnyObject]] ?? []
        let bracketsArray = Bracket.objects(from: brackets, context: context)
        
        for (index, bracket) in bracketsArray.enumerated() {
            bracket.sortOrder = index as NSNumber
        }
        
        round.brackets = NSSet(array: bracketsArray)
        
        let clusters = dictionary["Clusters"] as? [[String: AnyObject]] ?? []
        round.clusters = NSSet(array: Cluster.objects(from: clusters, context: context))
        
        let pools = dictionary["Pools"] as? [[String: AnyObject]] ?? []
        round.pools = NSSet(array: Pool.objects(from: pools, context: context))
        
        return round
    }
}
