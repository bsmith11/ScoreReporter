//
//  Team.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public typealias ImportCompletion = (NSError?) -> Void

public class Team: NSManagedObject {

}

// MARK: - Public

public extension Team {
    static func teams(from array: [[String: AnyObject]], completion: ImportCompletion?) {
        let block = { (context: NSManagedObjectContext) -> Void in
            Team.objects(from: array, context: context)
        }

        coreDataStack.performBlockUsingBackgroundContext(block, completion: completion)
    }

    static func fetchedBookmarkedTeams() -> NSFetchedResultsController<Team> {
        let predicate = NSPredicate(format: "%K == YES", #keyPath(Team.bookmarked))

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Team.name), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }

    static func fetchedTeams() -> NSFetchedResultsController<Team> {
        let predicate = NSPredicate(format: "%K != %@", #keyPath(Team.state), "")

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Team.state), ascending: true),
            NSSortDescriptor(key: #keyPath(Team.name), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors, sectionNameKeyPath: #keyPath(Team.state))
    }

    public static var searchFetchedResultsController: NSFetchedResultsController<Team> {
        let predicate = NSPredicate(format: "%K != nil", #keyPath(Team.state))

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Team.state), ascending: true),
            NSSortDescriptor(key: #keyPath(Team.name), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors, sectionNameKeyPath: #keyPath(Team.state))
    }

    static func stateName(fromAbbreviation abbreviation: String?) -> String? {
        guard let abbreviation = abbreviation else {
            return nil
        }

        let states = [
            "AL": "Alabama",
            "AK": "Alaska",
            "AZ": "Arizona",
            "AR": "Arkansas",
            "CA": "California",
            "CO": "Colorado",
            "CT": "Connecticut",
            "DE": "Delaware",
            "DC": "District of Columbia",
            "FL": "Florida",
            "GA": "Georgia",
            "HI": "Hawaii",
            "ID": "Idaho",
            "IL": "Illinois",
            "IN": "Indiana",
            "IA": "Iowa",
            "KS": "Kansas",
            "KY": "Kentucky",
            "LA": "Louisiana",
            "ME": "Maine",
            "MD": "Maryland",
            "MA": "Massachusetts",
            "MI": "Michigan",
            "MN": "Minnesota",
            "MS": "Mississippi",
            "MO": "Missouri",
            "MT": "Montana",
            "NE": "Nebraska",
            "NV": "Nevada",
            "NH": "New Hampshire",
            "NJ": "New Jersey",
            "NM": "New Mexico",
            "NY": "New York",
            "NC": "North Carolina",
            "ND": "North Dakota",
            "OH": "Ohio",
            "OK": "Oklahoma",
            "OR": "Oregon",
            "PA": "Pennsylvania",
            "RI": "Rhode Island",
            "SC": "South Carolina",
            "SD": "South Dakota",
            "TN": "Tennessee",
            "TX": "Texas",
            "UT": "Utah",
            "VT": "Vermont",
            "VA": "Virginia",
            "WA": "Washington",
            "WV": "West Virginia",
            "WI": "Wisconsin",
            "WY": "Wyoming",

            "AB": "Alberta",
            "BC": "British Columbia",
            "MB": "Manitoba",
            "NB": "New Brunswick",
            "NL": "Newfoundland",
            "NS": "Nova Scotia",
            "NT": "Northwest Territories",
            "NU": "Nunavut",
            "ON": "Ontario",
            "PE": "Prince Edward Island",
            "QC": "Quebec",
            "SK": "Saskatchewan",
            "YT": "Yukon"
        ]

        return states[abbreviation]
    }
}

// MARK: - Fetchable

extension Team: Fetchable {
    public static var primaryKey: String {
        return #keyPath(Team.teamID)
    }
}

// MARK: - CoreDataImportable

extension Team: CoreDataImportable {
    public static func object(from dictionary: [String: Any], context: NSManagedObjectContext) -> Team? {
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
        team.stateFull = Team.stateName(fromAbbreviation: team.state) ?? team.state
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

// MARK: - Searchable

extension Team: Searchable {
    public static var searchBarPlaceholder: String? {
        return "Find teams"
    }

    public static var searchEmptyTitle: String? {
        return "No Teams"
    }

    public static var searchEmptyMessage: String? {
        return "No teams exist by that name"
    }

    public static func predicate(with searchText: String?) -> NSPredicate? {
        let statePredicate = NSPredicate(format: "%K != nil", #keyPath(Team.state))

        guard let searchText = searchText, !searchText.isEmpty else {
            return statePredicate
        }

        let orPredicates = [
            NSPredicate(format: "%K contains[cd] %@", #keyPath(Team.name), searchText),
            NSPredicate(format: "%K contains[cd] %@", #keyPath(Team.school), searchText)
        ]

        let predicates = [
            statePredicate,
            NSCompoundPredicate(orPredicateWithSubpredicates: orPredicates)
        ]

        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }

    public var searchSectionTitle: String? {
        return stateFull
    }

    public var searchLogoURL: URL? {
        let baseURL = APIConstants.Path.baseURL

        return logoPath.flatMap { URL(string: "\(baseURL)\($0)") }
    }

    public var searchTitle: String? {
        return name ?? "No Name"
    }

    public var searchSubtitle: String? {
        let cityValue = city ?? "City"
        let stateValue = state ?? "State"

        return "\(cityValue), \(stateValue)"
    }
}
