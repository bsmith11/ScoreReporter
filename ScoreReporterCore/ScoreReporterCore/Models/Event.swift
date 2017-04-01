//
//  Event.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public class Event: NSManagedObject {
    
}

// MARK: - Public

public extension Event {
    static func events(from array: [[String: AnyObject]], completion: ImportCompletion?) {
        let block = { (context: NSManagedObjectContext) -> Void in
            Event.objects(from: array, context: context)
        }

        coreDataStack.performBlockUsingBackgroundContext(block, completion: completion)
    }

    static func fetchedUpcomingEventsFor(team: Team) -> NSFetchedResultsController<Event> {
        let predicates = [
            NSPredicate(format: "%K > %@", #keyPath(Event.startDate), NSDate()),
            NSPredicate(format: "SUBQUERY(%K, $x, $x in %@).@count > 0", #keyPath(Event.groups), team.groups)
        ]

        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Event.startDate), ascending: true),
            NSSortDescriptor(key: #keyPath(Event.name), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }

    static func fetchedEventsThisWeek() -> NSFetchedResultsController<Event> {
        let datesTuple = Date.enclosingDatesForCurrentWeek
        let predicate = NSPredicate(format: "%K > %@ AND %K < %@", #keyPath(Event.startDate), datesTuple.0 as NSDate, #keyPath(Event.startDate), datesTuple.1 as NSDate)

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Event.startDate), ascending: true),
            NSSortDescriptor(key: #keyPath(Event.name), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }

    static func fetchedBookmarkedEvents() -> NSFetchedResultsController<Event> {
        let predicate = NSPredicate(format: "%K == YES", #keyPath(Event.bookmarked))

        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Event.startDate), ascending: true),
            NSSortDescriptor(key: #keyPath(Event.name), ascending: true)
        ]

        return fetchedResultsController(predicate: predicate, sortDescriptors: sortDescriptors)
    }

    static func fetchedEvents() -> NSFetchedResultsController<Event> {
        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Event.startDate), ascending: true),
            NSSortDescriptor(key: #keyPath(Event.name), ascending: true)
        ]

        return fetchedResultsController(predicate: nil, sortDescriptors: sortDescriptors, sectionNameKeyPath: #keyPath(Event.startDate))
    }

    public static var searchFetchedResultsController: NSFetchedResultsController<Event> {
        let sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Event.startDate), ascending: true),
            NSSortDescriptor(key: #keyPath(Event.name), ascending: true)
        ]

        return fetchedResultsController(predicate: nil, sortDescriptors: sortDescriptors, sectionNameKeyPath: #keyPath(Event.startDate))
    }
}

// MARK: - Fetchable

extension Event: Fetchable {
    public static var primaryKey: String {
        return #keyPath(Event.eventID)
    }
}

// MARK: - CoreDataImportable

extension Event: CoreDataImportable {
    public static func object(from dictionary: [String: Any], context: NSManagedObjectContext) -> Event? {
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
            event.groups = NSSet(array: Group.objects(from: groups, context: context))
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

        return NSPredicate(format: "%K contains[cd] %@", #keyPath(Event.name), searchText)
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
