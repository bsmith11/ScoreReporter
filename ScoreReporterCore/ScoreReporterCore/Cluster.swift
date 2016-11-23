//
//  Cluster.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public class Cluster: NSManagedObject {

}

// MARK: - Public

public extension Cluster {
    func add(team: Team) {
        guard let games = games.allObjects as? [Game] else {
            return
        }

        games.forEach { $0.add(team: team) }
    }
}

// MARK: - Fetchable

extension Cluster: Fetchable {
    public static var primaryKey: String {
        return #keyPath(Cluster.clusterID)
    }
}

// MARK: - CoreDataImportable

extension Cluster: CoreDataImportable {
    public static func object(from dictionary: [String : AnyObject], context: NSManagedObjectContext) -> Cluster? {
        guard let clusterID = dictionary["ClusterId"] as? NSNumber else {
            return nil
        }

        guard let cluster = object(primaryKey: clusterID, context: context, createNew: true) else {
            return nil
        }

        cluster.clusterID = clusterID
        cluster.name = dictionary <~ "Name"

        let games = dictionary["Games"] as? [[String: AnyObject]] ?? []
        let gamesArray = Game.objects(from: games, context: context)

        for (index, game) in gamesArray.enumerated() {
            game.sortOrder = index as NSNumber
        }

        cluster.games = NSSet(array: gamesArray)

        if !cluster.hasPersistentChangedValues {
            context.refresh(cluster, mergeChanges: false)
        }

        return cluster
    }
}
