//
//  CoreDataStack.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import CoreData

public typealias CoreDataStackTransactionBlock = (NSManagedObjectContext) -> Void
public typealias CoreDataStackTransactionCompletion = (NSError?) -> Void

public class CoreDataStack: NSObject {
    private static let modelName = "ScoreReporter"
    
    private static var isRunningUnitTests: Bool {
        return NSProcessInfo.processInfo().environment["XCTestConfigurationFilePath"] != nil
    }
    
    private let backgroundQueue = dispatch_queue_create("com.bradsmith.ScoreReporter.backgroundContextQueue", DISPATCH_QUEUE_SERIAL)
    private let managedObjectModel: NSManagedObjectModel
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    private let storeURL: NSURL = {
        guard let directory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last else {
            preconditionFailure("Could not find document directory")
        }
        
        let filename = "\(CoreDataStack.modelName).sqlite"
        
        guard let URL = directory.URLByAppendingPathComponent(filename) else {
            preconditionFailure("Could not create store URL")
        }
        
        return URL
    }()
    
    public let mainContext: NSManagedObjectContext
    
    public static let sharedInstance = CoreDataStack()
    
    override init() {
        let bundle = NSBundle(forClass: self.dynamicType)
        managedObjectModel = NSManagedObjectModel.managedObjectModelFromName(CoreDataStack.modelName, bundle: bundle)
        
        let storeType = CoreDataStack.isRunningUnitTests ? NSInMemoryStoreType : NSSQLiteStoreType
        let options = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        persistentStoreCoordinator = NSPersistentStoreCoordinator.persistentStoreCoordinatorWithManagedObjectModel(managedObjectModel, storeType: storeType, storeURL: storeURL, options: options)
        
        mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        super.init()
    }
}

// MARK: - Public

public extension CoreDataStack {
    func performBlockUsingBackgroundContext(block: CoreDataStackTransactionBlock, completion: CoreDataStackTransactionCompletion?) {
        dispatch_async(backgroundQueue) {
            let context = self.backgroundContext()
            
            context.performBlockAndWait {
                block(context)
                
                let error = context.saveToStore()
                
                dispatch_async(dispatch_get_main_queue(), {
                    completion?(error)
                })
            }
            
            self.removeSaveNotificationsForContext(context)
        }
    }
}

// MARK: - Private

private extension CoreDataStack {
    func backgroundContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        
        addSaveNotificationsForContext(context)
        
        return context
    }
    
    func addSaveNotificationsForContext(context: NSManagedObjectContext) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(contextDidSave(_:)), name: NSManagedObjectContextDidSaveNotification, object: context)
    }
    
    func removeSaveNotificationsForContext(context: NSManagedObjectContext) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSManagedObjectContextDidSaveNotification, object: context)
    }
    
    @objc func contextDidSave(notification: NSNotification) {
        //TODO: - This may be overkill, but for now this should fault any objects that wouldn't normally get noticed by FRCs
        //        https://medium.com/bpxl-craft/nsfetchedresultscontroller-woes-3a9b485058#.du7vy78so
        let objects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject> ?? []
        
        mainContext.performBlockAndWait { [weak self] in
            objects.forEach({ object in
                let contextualObject = self?.mainContext.objectWithID(object.objectID)
                contextualObject?.willAccessValueForKey(nil)
            })
            
            self?.mainContext.mergeChangesFromContextDidSaveNotification(notification)
        }
    }
}

// MARK: - NSManagedObjectModel

extension NSManagedObjectModel {
    static func managedObjectModelFromName(name: String, bundle: NSBundle) -> NSManagedObjectModel {
        let URL = bundle.URLForResource(name, withExtension: "momd") ?? bundle.URLForResource(name, withExtension: "mom")
        
        guard let modelURL = URL else {
            preconditionFailure("Could not find resource \(name).momd or \(name).mom for path \(URL)")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL) else {
            preconditionFailure("Could not create managed object model for name \(name)")
        }
        
        return managedObjectModel
    }
}

// MARK: - NSPersistentStoreCoordinator

extension NSPersistentStoreCoordinator {
    static func persistentStoreCoordinatorWithManagedObjectModel(managedObjectModel: NSManagedObjectModel, storeType: String, storeURL: NSURL, options: [NSObject: AnyObject]) -> NSPersistentStoreCoordinator {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStoreWithType(storeType, configuration: nil, URL: storeURL, options: options)
        }
        catch(let error) {
            do {
                try NSFileManager.defaultManager().removeItemAtURL(storeURL)
                try persistentStoreCoordinator.addPersistentStoreWithType(storeType, configuration: nil, URL: storeURL, options: options)
            }
            catch(let removeError) {
                preconditionFailure("Unable to add persistent store. Attempted to delete old store, but failed.\n\nAdd error: \(error)\n\nDelete error: \(removeError)")
            }
        }
        
        return persistentStoreCoordinator
    }
}

// MARK: - NSManagedObjectContext

extension NSManagedObjectContext {
    func saveToStore() -> NSError? {
        var error: NSError?
        
        performBlockAndWait {
            if self.hasChanges {
                do {
                    try self.save()
                }
                catch(let saveError as NSError) {
                    error = saveError
                }
            }
        }
        
        return error
    }
}
