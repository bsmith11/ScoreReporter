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

// MARK: - Fetchable

extension Stage: Fetchable {
    static var primaryKey: String {
        return "stageID"
    }
}

// MARK: - CoreDataImportable

extension Stage: CoreDataImportable {
    static func objectFromDictionary(_ dictionary: [String : AnyObject], context: NSManagedObjectContext) -> Stage? {
        guard let stageID = dictionary["StageId"] as? NSNumber else {
            return nil
        }
        
        guard let stage = objectWithPrimaryKey(stageID, context: context, createNew: true) else {
            return nil
        }
        
        stage.stageID = stageID
        stage.name = dictionary["StageName"] as? String
        
        let games = dictionary["Games"] as? [[String: AnyObject]] ?? []
        let gamesArray = Game.objectsFromArray(games, context: context)
    
        for (index, game) in gamesArray.enumerated() {
            game.sortOrder = index as NSNumber
        }
        
        stage.games = NSSet(array: gamesArray)
        
        return stage
    }
}
