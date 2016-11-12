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
    static func objectFromDictionary(_ dictionary: [String : AnyObject], context: NSManagedObjectContext) -> Cluster? {
        guard let clusterID = dictionary["ClusterId"] as? NSNumber else {
            return nil
        }
        
        guard let cluster = objectWithPrimaryKey(clusterID, context: context, createNew: true) else {
            return nil
        }
        
        cluster.clusterID = clusterID
        cluster.name = dictionary["Name"] as? String
        
        let games = dictionary["Games"] as? [[String: AnyObject]] ?? []
        let gamesArray = Game.objectsFromArray(games, context: context)
        
        for (index, game) in gamesArray.enumerated() {
            game.sortOrder = index as NSNumber
        }
        
        cluster.games = NSSet(array: gamesArray)
        
        return cluster
    }
}
