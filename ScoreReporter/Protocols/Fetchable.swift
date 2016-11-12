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
        return String(describing: self)
    }
    
    static var coreDataStack: CoreDataStack {
        return CoreDataStack.sharedInstance
    }
    
    static func object(primaryKey: NSNumber, context: NSManagedObjectContext, createNew: Bool = false) -> FetchType? {
        let predicate = NSPredicate(format: "%K == %@", self.primaryKey, primaryKey)
        let object = self.object(in: context, predicate: predicate)
        
        if object == nil && createNew {
            return createObject(in: context)
        }
        else {
            return object
        }
    }
    
    static func object(in context: NSManagedObjectContext, predicate: NSPredicate? = nil) -> FetchType? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = predicate
        
        do {
            let objects = try context.fetch(fetchRequest) as? [FetchType] ?? []
            return objects.first
        }
        catch(let error) {
            print("Failed to fetch objects of type: \(self) with error: \(error)")
            return nil
        }
    }
    
    static func createObject(in context: NSManagedObjectContext) -> FetchType? {
        guard let object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? FetchType else {
            print("Failed to insert object as type \(self)")
            return nil
        }
        
        return object
    }
    
    static func fetchedResultsController(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, sectionNameKeyPath: String? = nil) -> NSFetchedResultsController<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
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
