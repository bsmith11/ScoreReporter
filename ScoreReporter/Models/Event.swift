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
    static func eventsFromArray(array: [[String: AnyObject]], completion: DownloadCompletion?) {
        let block = { (context: NSManagedObjectContext) -> Void in
            Event.objectsFromArray(array, context: context)
        }
        
        coreDataStack.performBlockUsingBackgroundContext(block, completion: completion)
    }
    
    static func fetchedEventsThisWeek() -> NSFetchedResultsController {
        let datesTuple = NSDate.enclosingDatesForCurrentWeek()
        
        let predicates = [
            NSPredicate(format: "%K == %@", "type", "Tournament"),
            NSPredicate(format: "%K > %@ AND %K < %@", "startDate", datesTuple.0, "startDate", datesTuple.1)
        ]
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        let sortDescriptors = [
            NSSortDescriptor(key: "startDate", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        return fetchedResultsControllerWithPredicate(predicate, sortDescriptors: sortDescriptors)
    }
    
    static func fetchedBookmarkedEvents() -> NSFetchedResultsController {
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
    
    static func fetchedEvents() -> NSFetchedResultsController {
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
    static func objectFromDictionary(dictionary: [String : AnyObject], context: NSManagedObjectContext) -> Event? {
        guard let eventID = dictionary["EventId"] as? Int else {
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
        event.startDate = startDate.flatMap { DateService.eventDateFormatter.dateFromString($0) }
        
        let endDate = dictionary["EndDate"] as? String
        event.endDate = endDate.flatMap { DateService.eventDateFormatter.dateFromString($0) }
        
        let logoPath = dictionary["EventLogo"] as? String
        event.logoPath = logoPathFromString(logoPath)

        let groups = dictionary["CompetitionGroup"] as? [[String: AnyObject]] ?? []
        event.groups = NSSet(array: Group.objectsFromArray(groups, context: context))
        
        return event
    }
    
    static func logoPathFromString(string: String?) -> String? {
        var components = string?.componentsSeparatedByString("\\")
        
        if components?.count > 2 {
            components?.insert("1", atIndex: 1)
        }
        
        return components?.joinWithSeparator("/")
    }
}

// MARK: - Searchable

extension Event: Searchable {
    static var searchFetchedResultsController: NSFetchedResultsController {
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
    
    static func predicateWithSearchText(searchText: String?) -> NSPredicate? {
        let typePredicate = NSPredicate(format: "%K == %@", "type", "Tournament")
        
        guard let searchText = searchText where !searchText.isEmpty else {
            return typePredicate
        }
        
        let predicates = [
            typePredicate,
            NSPredicate(format: "%K contains[cd] %@", "name", searchText)
        ]
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    var searchSectionTitle: String? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        return startDate.flatMap { dateFormatter.stringFromDate($0) }
    }
    
    var searchLogoURL: NSURL? {
        let baseURL = "http://play.usaultimate.org/"
        
        return logoPath.flatMap { NSURL(string: "\(baseURL)\($0)") }
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
