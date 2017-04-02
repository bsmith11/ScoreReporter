//
//  ManagedEvent.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public class ManagedEvent: NSManagedObject {
    
}

// MARK: - Public

public extension ManagedEvent {
    static func events(from array: [[String: AnyObject]], completion: ImportCompletion?) {
        let block = { (context: NSManagedObjectContext) -> Void in
            ManagedEvent.objects(from: array, context: context)
        }

        coreDataStack.performBlockUsingBackgroundContext(block, completion: completion)
    }

    static func fetchedUpcomingEventsFor(team: ManagedTeam) -> NSFetchedResultsController<ManagedEvent> {
        let predicates = [
            NSPredicate(format: "%K > %@", #keyPath(ManagedEvent.startDate), NSDate()),
            NSPredicate(format: "SUBQUERY(%K, $x, $x in %@).@count > 0", #keyPath(ManagedEvent.groups), team.groups)
        ]

        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedEvent.startDate), ascending: true),
            NSSortDescriptor(key: #keyPath(ManagedEvent.name), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }

    static func fetchedEventsThisWeek() -> NSFetchedResultsController<ManagedEvent> {
        let datesTuple = Date.enclosingDatesForCurrentWeek
        let predicate = NSPredicate(format: "%K > %@ AND %K < %@", #keyPath(ManagedEvent.startDate), datesTuple.0 as NSDate, #keyPath(ManagedEvent.startDate), datesTuple.1 as NSDate)

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedEvent.startDate), ascending: true),
            NSSortDescriptor(key: #keyPath(ManagedEvent.name), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }

    static func fetchedBookmarkedEvents() -> NSFetchedResultsController<ManagedEvent> {
        let predicate = NSPredicate(format: "%K == YES", #keyPath(ManagedEvent.bookmarked))

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedEvent.startDate), ascending: true),
            NSSortDescriptor(key: #keyPath(ManagedEvent.name), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }

    static func fetchedEvents() -> NSFetchedResultsController<ManagedEvent> {
        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedEvent.startDate), ascending: true),
            NSSortDescriptor(key: #keyPath(ManagedEvent.name), ascending: true)
        ]

        return fetchedResultsController(predicate: nil, sortDescriptors: sortDescriptors, sectionNameKeyPath: #keyPath(ManagedEvent.startDate))
    }

    public static var searchFetchedResultsController: NSFetchedResultsController<ManagedEvent> {
        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(ManagedEvent.startDate), ascending: true),
            NSSortDescriptor(key: #keyPath(ManagedEvent.name), ascending: true)
        ]

        return fetchedResultsController(predicate: nil, sortDescriptors: sortDescriptors, sectionNameKeyPath: #keyPath(ManagedEvent.startDate))
    }
}

// MARK: - Fetchable

extension ManagedEvent: Fetchable {
    public static var primaryKey: String {
        return #keyPath(ManagedEvent.eventID)
    }
}

// MARK: - CoreDataImportable

extension ManagedEvent: CoreDataImportable {
    public static func object(from dictionary: [String: Any], context: NSManagedObjectContext) -> ManagedEvent? {
        guard let eventID = dictionary[APIConstants.Response.Keys.eventID] as? NSNumber,
              let name = dictionary <~ APIConstants.Response.Keys.eventName,
              let type = dictionary <~ APIConstants.Response.Keys.eventType,
              type == APIConstants.Response.Values.tournament else {
            return nil
        }

        guard let event = object(primaryKey: eventID, context: context, createNew: true) else {
            return nil
        }

        event.eventID = eventID
        event.name = name

        if let _ = dictionary.index(forKey: APIConstants.Response.Keys.city) {
            event.city = dictionary <~ APIConstants.Response.Keys.city
        }

        if let _ = dictionary.index(forKey: APIConstants.Response.Keys.state) {
            event.state = dictionary <~ APIConstants.Response.Keys.state
        }

        if let _ = dictionary.index(forKey: APIConstants.Response.Keys.startDate) {
            let startDate = dictionary <~ APIConstants.Response.Keys.startDate
            event.startDate = startDate.flatMap { DateFormatter.eventDateFormatter.date(from: $0) }
        }

        if let _ = dictionary.index(forKey: APIConstants.Response.Keys.endDate) {
            let endDate = dictionary <~ APIConstants.Response.Keys.endDate
            event.endDate = endDate.flatMap { DateFormatter.eventDateFormatter.date(from: $0) }
        }

        if let _ = dictionary.index(forKey: APIConstants.Response.Keys.eventLogo) {
            let logoPath = dictionary <~ APIConstants.Response.Keys.eventLogo
            event.logoPath = self.logoPath(from: logoPath)
        }

        if let _ = dictionary.index(forKey: APIConstants.Response.Keys.competitionGroup) {
            let groups = dictionary[APIConstants.Response.Keys.competitionGroup] as? [[String: AnyObject]] ?? []
            event.groups = NSSet(array: ManagedGroup.objects(from: groups, context: context))
        }

        if !event.hasPersistentChangedValues {
            context.refresh(event, mergeChanges: false)
        }

        return event
    }

    static func logoPath(from string: String?) -> String? {
        guard let string = string else {
            return nil
        }

        var components = string.components(separatedBy: "\\")

        if components.count > 2 {
            components.insert("1", at: 1)
        }

        return components.joined(separator: "/")
    }
}

// MARK: - Searchable

extension ManagedEvent: Searchable {
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
        let baseURL = APIConstants.Path.baseURL

        return logoPath.flatMap { URL(string: "\(baseURL)\($0)") }
    }

    public var searchTitle: String? {
        return name
    }

    public var searchSubtitle: String? {
        let cityValue = city ?? "City"
        let stateValue = state ?? "State"

        return "\(cityValue), \(stateValue)"
    }
}
