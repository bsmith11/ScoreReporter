//
//  Event.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData
import RZImport

class Event: NSManagedObject {

}

// MARK: - Public

extension Event {
    static func eventsFromArrayWithCompletion(array: [[String: AnyObject]], completion: DownloadCompletion?) {
        let block = { (context: NSManagedObjectContext) -> Void in
            Event.rzi_objectsFromArray(array, inContext: context)
        }
        
        rzv_coreDataStack().performBlockUsingBackgroundContext(block, completion: completion)
    }
    
    static func fetchedEventsThisWeek() -> NSFetchedResultsController {
        let datesTuple = NSDate.enclosingDatesForCurrentWeek()
        
        let predicates = [
            NSPredicate(format: "%K == %@", "type", "Tournament"),
            NSPredicate(format: "%K > %@ AND %K < %@", "startDate", datesTuple.0, "startDate", datesTuple.1)
        ]
        
        let sortDescriptors = [
            NSSortDescriptor(key: "startDate", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        let request = NSFetchRequest(entityName: rzv_entityName())
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = sortDescriptors
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: rzv_coreDataStack().mainManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch let error as NSError {
            print("Failed to fetch events with error: \(error)")
        }
        
        return fetchedResultsController
    }
    
    static func fetchedBookmarkedEvents() -> NSFetchedResultsController {
        let predicates = [
            NSPredicate(format: "%K == %@", "type", "Tournament"),
            NSPredicate(format: "%K == YES", "bookmarked")
        ]
        
        let sortDescriptors = [
            NSSortDescriptor(key: "startDate", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        let request = NSFetchRequest(entityName: rzv_entityName())
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = sortDescriptors
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: rzv_coreDataStack().mainManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch let error as NSError {
            print("Failed to fetch events with error: \(error)")
        }
        
        return fetchedResultsController
    }
    
    static func fetchedEvents() -> NSFetchedResultsController {
        let predicate = NSPredicate(format: "%K == %@", "type", "Tournament")
        
        let sortDescriptors = [
            NSSortDescriptor(key: "startDate", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]

        let request = NSFetchRequest(entityName: rzv_entityName())
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: rzv_coreDataStack().mainManagedObjectContext, sectionNameKeyPath: "startDate", cacheName: nil)

        do {
            try fetchedResultsController.performFetch()
        }
        catch let error as NSError {
            print("Failed to fetch events with error: \(error)")
        }

        return fetchedResultsController
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

// MARK: - RZVinyl

extension Event {
    override class func rzv_externalPrimaryKey() -> String {
        return "EventId"
    }

    override class func rzv_primaryKey() -> String {
        return "eventID"
    }
}

// MARK: - RZImport

extension Event {
    override class func rzi_customMappings() -> [String: String] {
        return [
            "EventId": "eventID",
            "EventName": "name",
            "EventType": "type",
            "EventTypeName": "typeName",
            "City": "city",
            "State": "state"
        ]
    }

    override func rzi_shouldImportValue(value: AnyObject, forKey key: String) -> Bool {
        switch key {
        case "CompetitionGroup":
            if let value = value as? [[String: AnyObject]] {
                groups = NSSet(array: Group.rzi_objectsFromArray(value, inContext: managedObjectContext!))
            }
            else {
                groups = NSSet()
            }

            return false
        case "StartDate":
            if let value = value as? String {
                startDate = DateService.eventDateFormatter.dateFromString(value)
            }
            else {
                startDate = nil
            }

            return false
        case "EndDate":
            if let value = value as? String {
                endDate = DateService.eventDateFormatter.dateFromString(value)
            }
            else {
                endDate = nil
            }

            return false
        case "EventLogo":
            if let value = value as? String {
                var components = value.componentsSeparatedByString("\\")
                
                if components.count > 2 {
                    components.insert("1", atIndex: 1)

                    logoPath = components.joinWithSeparator("/")
                }
                else {
                    logoPath = nil
                }
            }
            else {
                logoPath = nil
            }

            return false
        default:
            return super.rzi_shouldImportValue(value, forKey: key)
        }
    }
}
