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

// MARK: - Public

extension Bracket {
    static func fetchedBracketsForGroup(group: Group) -> NSFetchedResultsController {
        let predicate = NSPredicate(format: "%K == %@", "round.group", group)
        
        let sortDescriptors = [
            NSSortDescriptor(key: "bracketID", ascending: true)
        ]
        
        return fetchedResultsControllerWithPredicate(predicate, sortDescriptors: sortDescriptors)
    }
}

// MARK: - Fetchable

extension Bracket: Fetchable {
    static var primaryKey: String {
        return "bracketID"
    }
}

// MARK: - CoreDataImportable

extension Bracket: CoreDataImportable {
    static func objectFromDictionary(dictionary: [String : AnyObject], context: NSManagedObjectContext) -> Bracket? {
        guard let bracketID = dictionary["BracketId"] as? Int else {
            return nil
        }
        
        guard let bracket = objectWithPrimaryKey(bracketID, context: context, createNew: true) else {
            return nil
        }
        
        bracket.bracketID = bracketID
        bracket.name = dictionary["BracketName"] as? String
        
        let stages = dictionary["Stage"] as? [[String: AnyObject]] ?? []
        bracket.stages = NSSet(array: Stage.objectsFromArray(stages, context: context))
        
        return bracket
    }
}
