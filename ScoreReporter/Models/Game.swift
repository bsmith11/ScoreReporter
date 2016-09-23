//
//  Game.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

class Game: NSManagedObject {

}

// MARK: - RZVinyl

extension Game {
    override class func rzv_shouldAlwaysCreateNewObjectOnImport() -> Bool {
        return true
    }
}

// MARK: - RZImport

extension Game {
    override class func rzi_customMappings() -> [String: String] {
        return [
            "HomeTeamName": "homeTeamName",
            "HomeTeamScore": "homeTeamScore",
            "AwayTeamName": "awayTeamName",
            "AwayTeamScore": "awayTeamScore",
            "GameStatus": "status",
            "FieldName": "fieldName"
        ]
    }

    override func rzi_shouldImportValue(value: AnyObject, forKey key: String) -> Bool {
        switch key {
        case "StartDate":
            if let value = value as? String {
                startDate = DateService.gameDateFormatter.dateFromString(value)
            }
            else {
                startDate = nil
            }

            return false
        case "StartTime":
            if let value = value as? String {
                startTime = DateService.gameTimeFormatter.dateFromString(value)
            }
            else {
                startTime = nil
            }

            return false
        default:
            return super.rzi_shouldImportValue(value, forKey: key)
        }
    }
}
