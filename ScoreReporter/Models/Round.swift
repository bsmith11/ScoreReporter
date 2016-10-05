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
    case Pools
    case Clusters
    case Brackets
    
    var title: String {
        switch self {
        case .Pools:
            return "Pools"
        case .Clusters:
            return "Crossovers"
        case .Brackets:
            return "Bracket"
        }
    }
}

class Round: NSManagedObject {
    var type: RoundType {
        if pools.count > 0 {
            return .Pools
        }
        else if clusters.count > 0 {
            return .Clusters
        }
        else {
            return .Brackets
        }
    }
}

// MARK: - RZVinyl

extension Round {
    override class func rzv_externalPrimaryKey() -> String {
        return "RoundId"
    }

    override class func rzv_primaryKey() -> String {
        return "roundID"
    }
}

// MARK: - RZImport

extension Round {
    override class func rzi_customMappings() -> [String: String] {
        return [
            "RoundId": "roundID"
        ]
    }

    override func rzi_shouldImportValue(value: AnyObject, forKey key: String) -> Bool {
        switch key {
        case "Brackets":
            if let value = value as? [[String: AnyObject]],
                bracketsArray = Bracket.rzi_objectsFromArray(value, inContext: managedObjectContext!) as? [Bracket] {
                for (index, bracket) in bracketsArray.enumerate() {
                    bracket.sortOrder = index
                }

                brackets = NSSet(array: bracketsArray)
            }
            else {
                brackets = NSSet()
            }

            return false
        case "Clusters":
            if let value = value as? [[String: AnyObject]] {
                clusters = NSSet(array: Cluster.rzi_objectsFromArray(value, inContext: managedObjectContext!))
            }
            else {
                clusters = NSSet()
            }

            return false
        case "Pools":
            if let value = value as? [[String: AnyObject]] {
                pools = NSSet(array: Pool.rzi_objectsFromArray(value, inContext: managedObjectContext!))
            }
            else {
                pools = NSSet()
            }

            return false
        default:
            return super.rzi_shouldImportValue(value, forKey: key)
        }
    }
}
