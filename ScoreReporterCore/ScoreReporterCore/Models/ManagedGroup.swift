//
//  ManagedGroup.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public class ManagedGroup: NSManagedObject {

}

// MARK: - Public

public extension ManagedGroup {
    static func groups(from array: [[String: AnyObject]], completion: ImportCompletion?) {
        let block = { (context: NSManagedObjectContext) -> Void in
            ManagedGroup.objects(from: array, context: context)
        }

        coreDataStack.performBlockUsingBackgroundContext(block, completion: completion)
    }
}

// MARK: - Fetchable

extension ManagedGroup: Fetchable {
    public static var primaryKey: String {
        return #keyPath(ManagedGroup.groupID)
    }
}

// MARK: - CoreDataImportable

extension ManagedGroup: CoreDataImportable {
    public static func object(from dictionary: [String: Any], context: NSManagedObjectContext) -> ManagedGroup? {
        guard let groupID = dictionary[APIConstants.Response.Keys.groupID] as? NSNumber else {
            return nil
        }

        guard let group = object(primaryKey: groupID, context: context, createNew: true) else {
            return nil
        }

        group.groupID = groupID

        if let divisionName = dictionary[APIConstants.Response.Keys.divisionName] {
            group.divisionName = divisionName as? String
        }

        if let teamCount = dictionary[APIConstants.Response.Keys.teamCount] {
            group.teamCount = teamCount as? String
        }

        let groupName = (dictionary[APIConstants.Response.Keys.groupName] as? String) ?? dictionary[APIConstants.Response.Keys.eventGroupName] as? String
        group.name = groupName

        let typeDivision = self.typeDivision(from: groupName)
        group.type = typeDivision.0
        group.division = typeDivision.1

        if let rounds = dictionary[APIConstants.Response.Keys.eventRounds] {
            let roundsArray = rounds as? [[String: AnyObject]] ?? []
            group.rounds = NSSet(array: ManagedRound.objects(from: roundsArray, context: context))
        }

        if !group.hasPersistentChangedValues {
            context.refresh(group, mergeChanges: false)
        }

        return group
    }

    static func typeDivision(from string: String?) -> (String?, String?) {
        let components = string?.components(separatedBy: "-")
        let set = CharacterSet.whitespacesAndNewlines
        let type = components?.first?.trimmingCharacters(in: set)
        let division = components?.last?.trimmingCharacters(in: set)

        return (type, division)
    }
}
