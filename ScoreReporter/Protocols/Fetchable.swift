//
//  Fetchable.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 10/29/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import CoreData

protocol Fetchable {
    associatedtype FetchType: NSManagedObject = Self
    
    static var primaryKey: String { get }
}

extension Fetchable where Self: NSManagedObject {
    static var entityName: String {
        return String(self)
    }
    
    static var coreDataStack: CoreDataStack {
        return CoreDataStack.sharedInstance
    }
    
    static func objectWithPrimaryKey(primaryKey: NSNumber, context: NSManagedObjectContext, createNew: Bool = false) -> FetchType? {
        let predicate = NSPredicate(format: "%K == %@", self.primaryKey, primaryKey)
        let object = objectInContext(context, predicate: predicate)
        
        if object == nil && createNew {
            return createObjectInContext(context)
        }
        else {
            return object
        }
    }
    
    static func objectInContext(context: NSManagedObjectContext, predicate: NSPredicate? = nil) -> FetchType? {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = predicate
        
        do {
            let objects = try context.executeFetchRequest(fetchRequest) as? [FetchType] ?? []
            return objects.first
        }
        catch(let error) {
            print("Failed to fetch objects of type: \(self) with error: \(error)")
            return nil
        }
    }
    
    static func createObjectInContext(context: NSManagedObjectContext) -> FetchType? {
        guard let object = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context) as? FetchType else {
            print("Failed to insert object as type \(self)")
            return nil
        }
        
        return object
    }
    
    static func fetchedResultsControllerWithPredicate(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, sectionNameKeyPath: String? = nil) -> NSFetchedResultsController {
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStack.mainContext, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch(let error) {
            print("Failed to fetch with error: \(error)")
        }
        
        return fetchedResultsController
    }
}
