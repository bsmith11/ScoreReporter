//
//  Event.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 4/2/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation

public struct Event {
    public let id: Int
    public let name: String
    public let city: String
    public let state: String
    public let startDate: Date?
    public let endDate: Date?
    public let latitude: Double?
    public let longitude: Double?
    public let logoUrl: URL?
    public let bookmarked: Bool
    public let groups: Set<Group>
    
    public init(event: ManagedEvent) {
        self.id = event.eventID.intValue
        self.name = event.name
        self.city = event.city ?? "No City"
        self.state = event.state ?? "No State"
        self.startDate = event.startDate
        self.endDate = event.endDate
        self.latitude = event.latitude?.doubleValue
        self.longitude = event.longitude?.doubleValue
        
        let baseUrl = APIConstants.Path.baseURL
        self.logoUrl = event.logoPath.flatMap { URL(string: "\(baseUrl)\($0)") }
        
        self.bookmarked = event.bookmarked.boolValue
        
        let managedGroup = event.groups as? Set<ManagedGroup> ?? []
        self.groups = Set(managedGroup.flatMap { Group(group: $0) })
    }
}

// MARK: - Public

public extension Event {
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

extension Event: Searchable {
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
        guard let searchText = searchText, !searchText.isEmpty else {
            return nil
        }
        
        return NSPredicate(format: "%K contains[cd] %@", #keyPath(ManagedEvent.name), searchText)
    }
    
    public var searchSectionTitle: String? {
        let dateFormatter = DateFormatter.eventSearchDateFormatter
        
        return startDate.flatMap { dateFormatter.string(from: $0 as Date) }
    }
    
    public var searchLogoURL: URL? {
        return logoUrl
    }
    
    public var searchTitle: String? {
        return name
    }
    
    public var searchSubtitle: String? {
        return [city, state].joined(separator: ", ")
    }
}

// MARK: - Hashable

extension Event: Hashable {
    public var hashValue: Int {
        return id
    }
    
    public static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}
