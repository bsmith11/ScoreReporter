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

// MARK: - Public

public extension Stage {
    func add(team: Team) {
        guard let games = games.allObjects as? [Game] else {
            return
        }

        games.forEach { $0.add(team: team) }
    }
}

// MARK: - Fetchable

extension Stage: Fetchable {
    public static var primaryKey: String {
        return #keyPath(Stage.stageID)
    }
}

// MARK: - CoreDataImportable

extension Stage: CoreDataImportable {
    public static func object(from dictionary: [String : AnyObject], context: NSManagedObjectContext) -> Stage? {
        guard let stageID = dictionary["StageId"] as? NSNumber else {
            return nil
        }

        guard let stage = object(primaryKey: stageID, context: context, createNew: true) else {
            return nil
        }

        stage.stageID = stageID
        stage.name = dictionary <~ "StageName"

        let games = dictionary["Games"] as? [[String: AnyObject]] ?? []
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
