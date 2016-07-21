//
//  Cluster.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

class Cluster: NSManagedObject {

}

// MARK: - RZVinyl

extension Cluster {
    override class func rzv_externalPrimaryKey() -> String {
        return "ClusterId"
    }

    override class func rzv_primaryKey() -> String {
        return "clusterID"
    }
}

// MARK: - RZImport

extension Cluster {
    override class func rzi_customMappings() -> [String: String] {
        return [
            "ClusterId": "clusterID",
            "Name": "name"
        ]
    }

    override func rzi_shouldImportValue(value: AnyObject, forKey key: String) -> Bool {
        switch key {
        case "Games":
            if let value = value as? [[String: AnyObject]],
                gamesArray = Game.rzi_objectsFromArray(value, inContext: managedObjectContext!) as? [Game] {
                gamesArray.forEach({$0.startDateFull = NSDate.dateWithDate($0.startDate, time: $0.startTime)})

                games = NSSet(array: gamesArray)
            }
            else {
                games = NSSet()
            }

            return false
        default:
            return super.rzi_shouldImportValue(value, forKey: key)
        }
    }
}
