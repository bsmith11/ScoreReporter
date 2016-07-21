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
