//
//  Event.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

class Event: NSManagedObject {
    
}

// MARK: - Public

extension Event {
    static func eventsFromArray(_ array: [[String: AnyObject]], completion: DownloadCompletion?) {
        let block = { (context: NSManagedObjectContext) -> Void in
            Event.objectsFromArray(array, context: context)
        }
        
        coreDataStack.performBlockUsingBackgroundContext(block, completion: completion)
    }
    
    static func fetchedEventsThisWeek() -> NSFetchedResultsController<NSFetchRequestResult> {
        let datesTuple = Date.enclosingDatesForCurrentWeek()
        
        let predicates = [
            NSPredicate(format: "%K == %@", "type", "Tournament"),
            NSPredicate(format: "%K > %@ AND %K < %@", "startDate", datesTuple.0 as NSDate, "startDate", datesTuple.1 as NSDate)
        ]
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        let sortDescriptors = [
            NSSortDescriptor(key: "startDate", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        return fetchedResultsControllerWithPredicate(predicate, sortDescriptors: sortDescriptors)
    }
    
    static func fetchedBookmarkedEvents() -> NSFetchedResultsController<NSFetchRequestResult> {
        let predicates = [
            NSPredicate(format: "%K == %@", "type", "Tournament"),
            NSPredicate(format: "%K == YES", "bookmarked")
        ]
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        let sortDescriptors = [
            NSSortDescriptor(key: "startDate", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        return fetchedResultsControllerWithPredicate(predicate, sortDescriptors: sortDescriptors)
    }
    
    static func fetchedEvents() -> NSFetchedResultsController<NSFetchRequestResult> {
        let predicate = NSPredicate(format: "%K == %@", "type", "Tournament")
        
        let sortDescriptors = [
            NSSortDescriptor(key: "startDate", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        return fetchedResultsControllerWithPredicate(predicate, sortDescriptors: sortDescriptors, sectionNameKeyPath: "startDate")
    }
}

// MARK: - Fetchable

extension Event: Fetchable {
    static var primaryKey: String {
        return "eventID"
    }
}

// MARK: - CoreDataImportable

extension Event: CoreDataImportable {
    static func objectFromDictionary(_ dictionary: [String : AnyObject], context: NSManagedObjectContext) -> Event? {
        guard let eventID = dictionary["EventId"] as? NSNumber else {
            return nil
        }
        
        guard let event = objectWithPrimaryKey(eventID, context: context, createNew: true) else {
            return nil
        }
        
        event.eventID = eventID
        event.name = dictionary["EventName"] as? String
        event.type = dictionary["EventType"] as? String
        event.typeName = dictionary["EventTypeName"] as? String
        event.city = dictionary["City"] as? String
        event.state = dictionary["State"] as? String
        
        let startDate = dictionary["StartDate"] as? String
        event.startDate = startDate.flatMap { DateService.eventDateFormatter.date(from: $0) }
        
        let endDate = dictionary["EndDate"] as? String
        event.endDate = endDate.flatMap { DateService.eventDateFormatter.date(from: $0) }
        
        let logoPath = dictionary["EventLogo"] as? String
        event.logoPath = logoPathFromString(logoPath)

        let groups = dictionary["CompetitionGroup"] as? [[String: AnyObject]] ?? []
        event.groups = NSSet(array: Group.objectsFromArray(groups, context: context))
        
        return event
    }
    
    static func logoPathFromString(_ string: String?) -> String? {
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
    static var searchFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> {
        let predicate = NSPredicate(format: "%K == %@", "type", "Tournament")
        
        let sortDescriptors = [
            NSSortDescriptor(key: "startDate", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        return fetchedResultsControllerWithPredicate(predicate, sortDescriptors: sortDescriptors, sectionNameKeyPath: "startDate")
    }
    
    static var searchBarPlaceholder: String? {
        return "Find events"
    }
    
    static var searchEmptyTitle: String? {
        return "No Events"
    }
    
    static var searchEmptyMessage: String? {
        return "No events exist by that name"
    }
    
    static func predicateWithSearchText(_ searchText: String?) -> NSPredicate? {
        let typePredicate = NSPredicate(format: "%K == %@", "type", "Tournament")
        
        guard let searchText = searchText, !searchText.isEmpty else {
            return typePredicate
        }
        
        let predicates = [
            typePredicate,
            NSPredicate(format: "%K contains[cd] %@", "name", searchText)
        ]
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    var searchSectionTitle: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        return startDate.flatMap { dateFormatter.string(from: $0 as Date) }
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
