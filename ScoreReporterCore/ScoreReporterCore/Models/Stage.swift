//
//  Stage.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public class Stage: NSManagedObject {

}

// MARK: - Fetchable

extension Stage: Fetchable {
    public static var primaryKey: String {
        return #keyPath(Stage.stageID)
    }
}

// MARK: - CoreDataImportable

extension Stage: CoreDataImportable {
    public static func object(from dictionary: [String: Any], context: NSManagedObjectContext) -> Stage? {
        guard let stageID = dictionary[APIConstants.Response.Keys.stageID] as? NSNumber else {
            return nil
        }

        guard let stage = object(primaryKey: stageID, context: context, createNew: true) else {
            return nil
        }

        stage.stageID = stageID
        stage.name = dictionary <~ APIConstants.Response.Keys.stageName

        let games = dictionary[APIConstants.Response.Keys.games] as? [[String: AnyObject]] ?? []
        let gamesArray = Game.objects(from: games, context: context)

        for (index, game) in gamesArray.enumerated() {
            game.sortOrder = index as NSNumber
        }

        stage.games = NSSet(array: gamesArray)

        if !stage.hasPersistentChangedValues {
            context.refresh(stage, mergeChanges: false)
        }

        return stage
    }
}
