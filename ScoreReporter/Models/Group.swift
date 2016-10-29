//
//  Group.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

enum GroupType: String {
    case Club = "Club"
    case College = "College"
    case Masters = "Masters"
    case HighSchool = "High School"
    case MiddleSchool = "Middle School"

    static func typeFromAPIString(string: String?) -> GroupType? {
        let components = string?.componentsSeparatedByString("-")
        let set = NSCharacterSet.whitespaceAndNewlineCharacterSet()

        guard let trimmedString = components?.first?.stringByTrimmingCharactersInSet(set) where components?.count > 1 else {
            return nil
        }

        return GroupType(rawValue: trimmedString)
    }
}

enum GroupDivision: String {
    case Mens = "Men"
    case Womens = "Women"
    case Mixed = "Mixed"
    case Boys = "Boys"
    case Girls = "Girls"

    static func divisionFromAPIString(string: String?) -> GroupDivision? {
        let components = string?.componentsSeparatedByString("-")
        let set = NSCharacterSet.whitespaceAndNewlineCharacterSet()

        guard let trimmedString = components?.last?.stringByTrimmingCharactersInSet(set).stringByReplacingOccurrencesOfString("'s", withString: "") where components?.count > 1 else {
            return nil
        }

        return GroupDivision(rawValue: trimmedString)
    }
}

class Group: NSManagedObject {

}

//MARK: - Public

extension Group {
    static func groupsFromArrayWithCompletion(array: [[String: AnyObject]], completion: DownloadCompletion?) {
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
    static func objectFromDictionary(dictionary: [String : AnyObject], context: NSManagedObjectContext) -> Group? {
        guard let groupID = dictionary["EventGroupId"] as? Int else {
            return nil
        }
        
        guard let group = objectWithPrimaryKey(groupID, context: context, createNew: true) else {
            return nil
        }
        
        group.groupID = groupID
        group.divisionName = dictionary["DivisionName"] as? String
        group.teamCount = dictionary["TeamCount"] as? String
        
        let groupName = dictionary["EventGroupName"] as? String
        group.name = groupName
        group.type = GroupType.typeFromAPIString(groupName)?.rawValue
        group.division = GroupDivision.divisionFromAPIString(groupName)?.rawValue
        
        let rounds = dictionary["EventRounds"] as? [[String: AnyObject]] ?? []
        group.rounds = NSSet(array: Round.objectsFromArray(rounds, context: context))
        
        return group
    }
}
