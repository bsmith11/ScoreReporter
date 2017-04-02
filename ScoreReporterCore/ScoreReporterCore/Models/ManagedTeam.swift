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
        team.stateFull = ManagedTeam.stateName(fromAbbreviation: team.state) ?? team.state
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

extension ManagedTeam: Searchable {
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
        let statePredicate = NSPredicate(format: "%K != nil", #keyPath(ManagedTeam.state))

        guard let searchText = searchText, !searchText.isEmpty else {
            return statePredicate
        }

        let orPredicates = [
            NSPredicate(format: "%K contains[cd] %@", #keyPath(ManagedTeam.name), searchText),
            NSPredicate(format: "%K contains[cd] %@", #keyPath(ManagedTeam.school), searchText)
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
