//
//  Bracket.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public class Bracket: NSManagedObject {
    
}

// MARK: - Public

public extension Bracket {
    static func fetchedBracketsForGroup(_ group: Group) -> NSFetchedResultsController<NSFetchRequestResult> {
        let predicate = NSPredicate(format: "%K == %@", "round.group", group)
        
        let sortDescriptors = [
            NSSortDescriptor(key: "bracketID", ascending: true)
        ]
        
        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }
}

// MARK: - Fetchable

extension Bracket: Fetchable {
    public static var primaryKey: String {
        return "bracketID"
    }
}

// MARK: - CoreDataImportable

extension Bracket: CoreDataImportable {
    public static func object(from dictionary: [String : AnyObject], context: NSManagedObjectContext) -> Bracket? {
        guard let bracketID = dictionary["BracketId"] as? NSNumber else {
            return nil
        }
        
        guard let bracket = object(primaryKey: bracketID, context: context, createNew: true) else {
            return nil
        }
        
        bracket.bracketID = bracketID
        bracket.name = dictionary["BracketName"] as? String
        
        let stages = dictionary["Stage"] as? [[String: AnyObject]] ?? []
        bracket.stages = NSSet(array: Stage.objects(from: stages, context: context))
        
        return bracket
    }
}
