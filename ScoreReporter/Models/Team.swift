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
    static func teamsFromArray(_ array: [[String: AnyObject]], completion: DownloadCompletion?) {
        let block = { (context: NSManagedObjectContext) -> Void in
            Team.objectsFromArray(array, context: context)
        }
        
        coreDataStack.performBlockUsingBackgroundContext(block, completion: completion)
    }
    
    static func fetchedTeams() -> NSFetchedResultsController<NSFetchRequestResult> {
        let predicate = NSPredicate(format: "%K != %@", "state", "")
        
        let sortDescriptors = [
            NSSortDescriptor(key: "state", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        return fetchedResultsControllerWithPredicate(predicate, sortDescriptors: sortDescriptors, sectionNameKeyPath: "state")
    }
}

// MARK: - Private

private extension Team {
    static func stateNameForAbbreviation(_ abbreviation: String?) -> String? {
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
    static var primaryKey: String {
        return "teamID"
    }
}

// MARK: - CoreDataImportable

extension Team: CoreDataImportable {
    static func objectFromDictionary(_ dictionary: [String : AnyObject], context: NSManagedObjectContext) -> Team? {
        guard let teamID = dictionary["TeamId"] as? NSNumber else {
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
        team.stateFull = Team.stateNameForAbbreviation(team.state) ?? team.state
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
    guard let value = lhs[rhs] as? String, !value.isEmpty else {
        return nil
    }
    
    return value
}

// MARK: - Searchable

extension Team: Searchable {
    static var searchFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> {
        let predicate = NSPredicate(format: "%K != nil", "state")
        
        let sortDescriptors = [
            NSSortDescriptor(key: "state", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        return fetchedResultsControllerWithPredicate(predicate, sortDescriptors: sortDescriptors, sectionNameKeyPath: "state")
    }
    
    static var searchBarPlaceholder: String? {
        return "Find teams"
    }
    
    static var searchEmptyTitle: String? {
        return "No Teams"
    }
    
    static var searchEmptyMessage: String? {
        return "No teams exist by that name"
    }
    
    static func predicateWithSearchText(_ searchText: String?) -> NSPredicate? {
        let statePredicate = NSPredicate(format: "%K != nil", "state")
        
        guard let searchText = searchText, !searchText.isEmpty else {
            return statePredicate
        }
        
        let orPredicates = [
            NSPredicate(format: "%K contains[cd] %@", "name", searchText),
            NSPredicate(format: "%K contains[cd] %@", "school", searchText)
        ]
        
        let predicates = [
            statePredicate,
            NSCompoundPredicate(orPredicateWithSubpredicates: orPredicates)
        ]
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    var searchSectionTitle: String? {
        return stateFull
    }
    
    var searchLogoURL: URL? {
        let baseURL = "http://play.usaultimate.org/"
        
        return logoPath.flatMap { URL(string: "\(baseURL)\($0)") }
    }
    
    var searchTitle: String? {
        return name ?? "No Name"
    }
    
    var searchSubtitle: String? {
        let cityValue = city ?? "City"
        let stateValue = state ?? "State"
        
        return "\(cityValue), \(stateValue)"
    }
}
