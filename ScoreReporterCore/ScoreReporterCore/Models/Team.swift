//
//  Team.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 4/2/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation

public struct Team {
    public let id: Int
    public let name: String
    public let city: String
    public let state: String
    public let stateFull: String
    public let school: String?
    public let division: String?
    public let competitionLevel: String?
    public let designation: String?
    public let bookmarked: Bool
    public let homeGames: Set<Game>
    public let awayGames: Set<Game>
    
    public let fullName: String?
    public let competitionDivision: String?
    public let location: String?
    public let logoUrl: URL?
    
    public init(team: ManagedTeam) {
        self.id = team.teamID.intValue
        self.name = team.name ?? "No Name"
        self.city = team.city ?? "No City"
        self.state = team.state ?? "No State"
        self.stateFull = String.stateName(fromAbbreviation: self.state) ?? "No State"
        
        self.school = team.school
        self.division = team.division
        self.competitionLevel = team.competitionLevel
        self.designation = team.designation
        self.bookmarked = team.bookmarked.boolValue
        
        let managedHomeGames = team.homeGames as? Set<ManagedGame> ?? []
        self.homeGames = Set(managedHomeGames.flatMap { Game(game: $0) })
        
        let managedAwayGames = team.awayGames as? Set<ManagedGame> ?? []
        self.awayGames = Set(managedAwayGames.flatMap { Game(game: $0) })
        
        self.fullName = [team.school, team.name].joined(by: " ")
        self.competitionDivision = [team.competitionLevel, team.division].joined(by: " ")
        self.location = [team.city, team.state].joined(by: ", ")
        
        let baseUrl = APIConstants.Path.baseURL
        self.logoUrl = team.logoPath.flatMap { URL(string: "\(baseUrl)\($0)") }
    }
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
        return logoUrl
    }
    
    public var searchTitle: String? {
        return name
    }
    
    public var searchSubtitle: String? {
        return location
    }
}

// MARK: - Hashable

extension Team: Hashable {
    public var hashValue: Int {
        return id
    }
    
    public static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.id == rhs.id
    }
}
