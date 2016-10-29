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
    static func eventsFromArrayWithCompletion(array: [[String: AnyObject]], completion: DownloadCompletion?) {
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
    
    static func searchPredicateWithText(text: String?) -> NSPredicate {
        let typePredicate = NSPredicate(format: "%K == %@", "type", "Tournament")
        
        guard let text = text where !text.isEmpty else {
            return typePredicate
        }
        
        let predicates = [
            typePredicate,
            NSPredicate(format: "%K contains[cd] %@", "name", text)
        ]
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
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
