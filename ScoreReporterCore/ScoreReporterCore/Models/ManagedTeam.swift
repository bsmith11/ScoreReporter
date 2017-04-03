//
//  ManagedTeam.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public typealias ImportCompletion = (NSError?) -> Void

public class ManagedTeam: NSManagedObject {

}

// MARK: - Public

public extension ManagedTeam {
    static func teams(from array: [[String: AnyObject]], completion: ImportCompletion?) {
        let block = { (context: NSManagedObjectContext) -> Void in
            ManagedTeam.objects(from: array, context: context)
        }

        coreDataStack.performBlockUsingBackgroundContext(block, completion: completion)
    }

    static func fetchedBookmarkedTeams() -> NSFetchedResultsController<ManagedTeam> {
        let predicate = NSPredicate(format: "%K == YES", #keyPath(ManagedTeam.bookmarked))

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedTeam.name), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }

    static func fetchedTeams() -> NSFetchedResultsController<ManagedTeam> {
        let predicate = NSPredicate(format: "%K != %@", #keyPath(ManagedTeam.state), "")

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedTeam.state), ascending: true),
            NSSortDescriptor(key: #keyPath(ManagedTeam.name), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors, sectionNameKeyPath: #keyPath(ManagedTeam.state))
    }

    public static var searchFetchedResultsController: NSFetchedResultsController<ManagedTeam> {
        let predicate = NSPredicate(format: "%K != nil", #keyPath(ManagedTeam.state))

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedTeam.state), ascending: true),
            NSSortDescriptor(key: #keyPath(ManagedTeam.name), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors, sectionNameKeyPath: #keyPath(ManagedTeam.state))
    }
}

// MARK: - Fetchable

extension ManagedTeam: Fetchable {
    public static var primaryKey: String {
        return #keyPath(ManagedTeam.teamID)
    }
}

// MARK: - CoreDataImportable

extension ManagedTeam: CoreDataImportable {
    public static func object(from dictionary: [String: Any], context: NSManagedObjectContext) -> ManagedTeam? {
        guard let teamID = dictionary[APIConstants.Response.Keys.teamID] as? NSNumber else {
            return nil
        }

        guard let team = object(primaryKey: teamID, context: context, createNew: true) else {
            return nil
        }

        team.teamID = teamID
        team.name = dictionary <~ APIConstants.Response.Keys.teamName
        team.logoPath = dictionary <~ APIConstants.Response.Keys.teamLogo
        team.city = dictionary <~ APIConstants.Response.Keys.city
        team.state = dictionary <~ APIConstants.Response.Keys.state
        team.school = dictionary <~ APIConstants.Response.Keys.schoolName
        team.division = dictionary <~ APIConstants.Response.Keys.divisionName
        team.competitionLevel = dictionary <~ APIConstants.Response.Keys.competitionLevel
        team.designation = dictionary <~ APIConstants.Response.Keys.teamDesignation

        if !team.hasPersistentChangedValues {
            context.refresh(team, mergeChanges: false)
        }

        return team
    }
}

infix operator <~ {
associativity none
precedence 100
}

func <~ (lhs: [String: Any], rhs: String) -> String? {
    guard let value = lhs[rhs] as? String, !value.isEmpty else {
        return nil
    }

    return value
}
