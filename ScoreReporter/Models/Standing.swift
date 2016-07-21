//
//  Standing.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

class Standing: NSManagedObject {

}

// MARK: - RZVinyl

extension Standing {
    override class func rzv_shouldAlwaysCreateNewObjectOnImport() -> Bool {
        return true
    }
}

// MARK: - RZImport

extension Standing {
    override class func rzi_customMappings() -> [String: String] {
        return [
            "TeamName": "teamName",
            "Wins": "wins",
            "Losses": "losses",
            "SortOrder": "sortOrder"
        ]
    }

    override static func rzi_ignoredKeys() -> [String] {
        return [
            "Points",
            "TieBreaker",
            "GoalsFor",
            "GoalDifferential",
            "Ties",
            "GoalsAgainst"
        ]
    }

    override func rzi_shouldImportValue(value: AnyObject, forKey key: String) -> Bool {
        switch key {
        case "TeamName":
            if let value = value as? String {
                let pattern = "([0-9]+)"

                if let seedValue = value.stringMatchingRegexPattern(pattern) where !seedValue.isEmpty {
                    seed = Int(seedValue)
                }
                else {
                    seed = 0
                }
            }
            else {
                seed = 0
            }

            return false
        default:
            return super.rzi_shouldImportValue(value, forKey: key)
        }
    }
}
