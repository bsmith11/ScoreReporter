//
//  EventViewModel.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 3/31/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation

public struct EventViewModel {
    public let eventID: Int
    public let name: String
    public let city: String
    public let state: String
    public let startDate: Date?
    public let endDate: Date?
    public let latitude: Double?
    public let longitude: Double?
    public let logoURL: URL?
    public let type: String?
    public let typeName: String?
    public let bookmarked: Bool
    public let groups: Set<GroupViewModel>
    
    public init(event: Event) {
        self.eventID = event.eventID.intValue
        self.name = event.name ?? "No Name"
        self.city = event.city ?? "No City"
        self.state = event.state ?? "No State"
        self.startDate = event.startDate
        self.endDate = event.endDate
        self.latitude = event.latitude?.doubleValue
        self.longitude = event.longitude?.doubleValue
        
        let baseURL = APIConstants.Path.baseURL
        self.logoURL = event.logoPath.flatMap { URL(string: "\(baseURL)\($0)") }
        
        self.type = event.type
        self.typeName = event.typeName
        self.bookmarked = event.bookmarked.boolValue
        
        let groups = event.groups as? Set<Group> ?? []
        self.groups = Set(groups.map { GroupViewModel(group: $0) })
    }
}

// MARK: - Public

public extension EventViewModel {
    var dateRange: String {
        let dateFormatter = DateFormatter.eventDetailsDateFormatter
        let calendar = Calendar.current
        
        guard let startDate = startDate else {
            return "No dates"
        }
        
        let startDateString = dateFormatter.string(from: startDate)
        
        guard let endDate = endDate else {
            return startDateString
        }
        
        guard calendar.compare(startDate, to: endDate, toGranularity: .day) != .orderedSame else {
            return startDateString
        }
        
        let endDateString = dateFormatter.string(from: endDate)
        
        return "\(startDateString) - \(endDateString)"
    }
    
    var cityState: String {
        return [city, state].joined(separator: ", ")
    }
}

// MARK: - Searchable

extension EventViewModel: Searchable {
    public static var searchBarPlaceholder: String? {
        return "Find events"
    }
    
    public static var searchEmptyTitle: String? {
        return "No Events"
    }
    
    public static var searchEmptyMessage: String? {
        return "No events exist by that name"
    }
    
    public static func predicate(with searchText: String?) -> NSPredicate? {
        let typePredicate = NSPredicate(format: "%K == %@", #keyPath(Event.type), APIConstants.Response.Values.tournament)
        
        guard let searchText = searchText, !searchText.isEmpty else {
            return typePredicate
        }
        
        let predicates = [
            typePredicate,
            NSPredicate(format: "%K contains[cd] %@", #keyPath(Event.name), searchText)
        ]
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    public var searchSectionTitle: String? {
        let dateFormatter = DateFormatter.eventSearchDateFormatter
        
        return startDate.flatMap { dateFormatter.string(from: $0 as Date) }
    }
    
    public var searchLogoURL: URL? {
        return logoURL
    }
    
    public var searchTitle: String? {
        return name
    }
    
    public var searchSubtitle: String? {
        return [city, state].joined(separator: ", ")
    }
}
