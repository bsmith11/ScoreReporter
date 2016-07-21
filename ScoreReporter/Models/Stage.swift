//
//  Stage.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

class Stage: NSManagedObject {

}

// MARK: - RZVinyl

extension Stage {
    override class func rzv_externalPrimaryKey() -> String {
        return "StageId"
    }

    override class func rzv_primaryKey() -> String {
        return "stageID"
    }
}

// MARK: - RZImport

extension Stage {
    override class func rzi_customMappings() -> [String: String] {
        return [
            "StageId": "stageID",
            "StageName": "name"
        ]
    }

    override func rzi_shouldImportValue(value: AnyObject, forKey key: String) -> Bool {
        switch key {
        case "Games":
            if let value = value as? [[String: AnyObject]],
                gamesArray = Game.rzi_objectsFromArray(value, inContext: managedObjectContext!) as? [Game] {
                for (index, game) in gamesArray.enumerate() {
                    game.startDateFull = NSDate.dateWithDate(game.startDate, time: game.startTime)
                    game.sortOrder = index
                }

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
