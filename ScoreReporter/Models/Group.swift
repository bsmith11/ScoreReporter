//
//  Group.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

class Group: NSManagedObject {

}

//MARK: - Public

extension Group {
    static func groupsFromArray(_ array: [[String: AnyObject]], completion: DownloadCompletion?) {
        let block = { (context: NSManagedObjectContext) -> Void in
            Group.objectsFromArray(array, context: context)
        }
        
        coreDataStack.performBlockUsingBackgroundContext(block, completion: completion)        
    }
}

// MARK: - Fetchable

extension Group: Fetchable {
    static var primaryKey: String {
        return "groupID"
    }
}

// MARK: - CoreDataImportable

extension Group: CoreDataImportable {
    static func objectFromDictionary(_ dictionary: [String : AnyObject], context: NSManagedObjectContext) -> Group? {
        guard let groupID = dictionary["EventGroupId"] as? NSNumber else {
            return nil
        }
        
        guard let group = objectWithPrimaryKey(groupID, context: context, createNew: true) else {
            return nil
        }
        
        group.groupID = groupID
        
        if let divisionName = dictionary["DivisionName"] {
            group.divisionName = divisionName as? String
        }
        
        if let teamCount = dictionary["TeamCount"] {
            group.teamCount = teamCount as? String
        }
        
        let groupName = (dictionary["GroupName"] as? String) ?? dictionary["EventGroupName"] as? String
        group.name = groupName
        
        let typeDivision = typeDivisionFromString(groupName)
        group.type = typeDivision.0
        group.division = typeDivision.1
        
        if let rounds = dictionary["EventRounds"] {
            let roundsArray = rounds as? [[String: AnyObject]] ?? []
            group.rounds = NSSet(array: Round.objectsFromArray(roundsArray, context: context))
        }
        
        return group
    }
    
    static func typeDivisionFromString(_ string: String?) -> (String?, String?) {
        let components = string?.components(separatedBy: "-")
        let set = CharacterSet.whitespacesAndNewlines
        let type = components?.first?.trimmingCharacters(in: set)
        let division = components?.last?.trimmingCharacters(in: set)
        
        return (type, division)
    }
}
