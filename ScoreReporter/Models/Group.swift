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
    case Unknown = "Unknown"
    case Club = "Club"
    case College = "College"
    case Masters = "Masters"
    case HighSchool = "High School"
    case MiddleSchool = "Middle School"

    static func typeFromAPIString(string: String?) -> GroupType {
        let components = string?.componentsSeparatedByString("-")
        let set = NSCharacterSet.whitespaceAndNewlineCharacterSet()

        guard let trimmedString = components?.first?.stringByTrimmingCharactersInSet(set) where components?.count > 1 else {
            return .Unknown
        }

        return GroupType(rawValue: trimmedString) ?? .Unknown
    }
}

enum GroupDivision: String {
    case Unknown = "Unknown"
    case Mens = "Men"
    case Womens = "Women"
    case Mixed = "Mixed"
    case Boys = "Boys"
    case Girls = "Girls"

    static func divisionFromAPIString(string: String?) -> GroupDivision {
        let components = string?.componentsSeparatedByString("-")
        let set = NSCharacterSet.whitespaceAndNewlineCharacterSet()

        guard let trimmedString = components?.last?.stringByTrimmingCharactersInSet(set).stringByReplacingOccurrencesOfString("'s", withString: "") where components?.count > 1 else {
            return .Unknown
        }

        return GroupDivision(rawValue: trimmedString) ?? .Unknown
    }
}

class Group: NSManagedObject {

}

// MARK: - RZVinyl

extension Group {
    override class func rzv_externalPrimaryKey() -> String {
        return "EventGroupId"
    }

    override class func rzv_primaryKey() -> String {
        return "groupID"
    }
}

// MARK: - RZImport

extension Group {
    override class func rzi_customMappings() -> [String: String] {
        return [
            "EventGroupId": "groupID",
            "EventGroupName": "name",
            "GroupName": "name",
            "DivisionName": "divisionName",
            "TeamCount": "teamCount"
        ]
    }

    override func rzi_shouldImportValue(value: AnyObject, forKey key: String) -> Bool {
        switch key {
        case "EventRounds":
            if let value = value as? [[String: AnyObject]] {
                rounds = NSSet(array: Round.rzi_objectsFromArray(value, inContext: managedObjectContext!))
            }
            else {
                rounds = NSSet()
            }

            return false
        case "GroupName":
            type = GroupType.typeFromAPIString(value as? String).rawValue
            division = GroupDivision.divisionFromAPIString(value as? String).rawValue

            return false
        default:
            return super.rzi_shouldImportValue(value, forKey: key)
        }
    }
}
