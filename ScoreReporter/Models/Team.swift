//
//  Team.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

class Team: NSManagedObject {
    
}

// MARK: - Public

extension Team {
    static func teamsFromArray(array: [[String: AnyObject]], completion: DownloadCompletion?) {
        let block = { (context: NSManagedObjectContext) -> Void in
            Team.objectsFromArray(array, context: context)
        }
        
        coreDataStack.performBlockUsingBackgroundContext(block, completion: completion)
    }
    
    static func fetchedTeams() -> NSFetchedResultsController {
        let predicate = NSPredicate(format: "%K != %@", "state", "")
        
        let sortDescriptors = [
            NSSortDescriptor(key: "state", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        return fetchedResultsControllerWithPredicate(predicate, sortDescriptors: sortDescriptors, sectionNameKeyPath: "state")
    }
    
    static func searchPredicateWithText(text: String?) -> NSPredicate {
        let statePredicate = NSPredicate(format: "%K != nil", "state")
        
        guard let text = text where !text.isEmpty else {
            return statePredicate
        }
        
        let orPredicates = [
            NSPredicate(format: "%K contains[cd] %@", "name", text),
            NSPredicate(format: "%K contains[cd] %@", "school", text)
        ]
        
        let predicates = [
            statePredicate,
            NSCompoundPredicate(orPredicateWithSubpredicates: orPredicates)
        ]
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
}

// MARK: - Fetchable

extension Team: Fetchable {
    static var primaryKey: String {
        return "teamID"
    }
}

// MARK: - CoreDataImportable

extension Team: CoreDataImportable {
    static func objectFromDictionary(dictionary: [String : AnyObject], context: NSManagedObjectContext) -> Team? {
        guard let teamID = dictionary["TeamId"] as? Int else {
            return nil
        }
        
        guard let team = objectWithPrimaryKey(teamID, context: context, createNew: true) else {
            return nil
        }
        
        team.teamID = teamID
        team.name = dictionary <~ "TeamName"
        team.logoPath = dictionary <~ "TeamLogo"
        team.city = dictionary <~ "City"
        team.state = dictionary <~ "State"
        team.school = dictionary <~ "SchoolName"
        team.division = dictionary <~ "DivisionName"
        team.competitionLevel = dictionary <~ "CompetitionLevel"
        team.designation = dictionary <~ "TeamDesignation"
        
        return team
    }
}

infix operator <~ {
associativity none
precedence 100
}

func <~ (lhs: [String: AnyObject], rhs: String) -> String? {
    guard let value = lhs[rhs] as? String where !value.isEmpty else {
        return nil
    }
    
    return value
}
