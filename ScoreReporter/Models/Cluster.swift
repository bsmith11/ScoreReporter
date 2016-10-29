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

// MARK: - Fetchable

extension Cluster: Fetchable {
    static var primaryKey: String {
        return "clusterID"
    }
}

// MARK: - CoreDataImportable

extension Cluster: CoreDataImportable {
    static func objectFromDictionary(dictionary: [String : AnyObject], context: NSManagedObjectContext) -> Cluster? {
        guard let clusterID = dictionary["ClusterId"] as? Int else {
            return nil
        }
        
        guard let cluster = objectWithPrimaryKey(clusterID, context: context, createNew: true) else {
            return nil
        }
        
        cluster.clusterID = clusterID
        cluster.name = dictionary["Name"] as? String
        
        let games = dictionary["Games"] as? [[String: AnyObject]] ?? []
        let gamesArray = Game.objectsFromArray(games, context: context)
        
        for (index, game) in gamesArray.enumerate() {
            game.sortOrder = index
        }
        
        cluster.games = NSSet(array: gamesArray)
        
        return cluster
    }
}
