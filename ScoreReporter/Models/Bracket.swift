//
//  Bracket.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

class Bracket: NSManagedObject {

}

// MARK: - RZVinyl

extension Bracket {
    override class func rzv_externalPrimaryKey() -> String {
        return "BracketId"
    }

    override class func rzv_primaryKey() -> String {
        return "bracketID"
    }
}

// MARK: - RZImport

extension Bracket {
    override class func rzi_customMappings() -> [String: String] {
        return [
            "BracketId": "bracketID",
            "BracketName": "name"
        ]
    }

    override func rzi_shouldImportValue(value: AnyObject, forKey key: String) -> Bool {
        switch key {
        case "Stage":
            if let value = value as? [[String: AnyObject]] {
                stages = NSSet(array: Stage.rzi_objectsFromArray(value, inContext: managedObjectContext!))
            }
            else {
                stages = NSSet()
            }

            return false
        default:
            return super.rzi_shouldImportValue(value, forKey: key)
        }
    }
}
