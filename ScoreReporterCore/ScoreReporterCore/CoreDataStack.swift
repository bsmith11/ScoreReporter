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
    fileprivate static let modelName = "ScoreReporter"
    
    fileprivate static var isRunningUnitTests: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    fileprivate let backgroundQueue = DispatchQueue(label: "com.bradsmith.ScoreReporter.backgroundContextQueue", attributes: [])
    fileprivate let managedObjectModel: NSManagedObjectModel
    fileprivate let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    fileprivate let storeURL: URL = {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            preconditionFailure("Could not find document directory")
        }
        
        let filename = "\(CoreDataStack.modelName).sqlite"
        let URL = directory.appendingPathComponent(filename)
        
        return URL
    }()
    
    public let mainContext: NSManagedObjectContext
    
    public static let sharedInstance = CoreDataStack()
    
    private override init() {
        let bundle = Bundle(for: type(of: self))
        managedObjectModel = NSManagedObjectModel.managedObjectModel(name: CoreDataStack.modelName, bundle: bundle)
        
        let storeType = CoreDataStack.isRunningUnitTests ? NSInMemoryStoreType : NSSQLiteStoreType
        let options = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        persistentStoreCoordinator = NSPersistentStoreCoordinator.persistentStoreCoordinator(managedObjectModel: managedObjectModel, storeType: storeType, storeURL: storeURL, options: options)
        
        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        super.init()
    }
}

// MARK: - Public

public extension CoreDataStack {
    func performBlockUsingBackgroundContext(_ block: @escaping CoreDataStackTransactionBlock, completion: CoreDataStackTransactionCompletion?) {
        backgroundQueue.async {
            let context = self.backgroundContext()
            
            context.performAndWait {
                block(context)
                
                let error = context.saveToStore()
                
                DispatchQueue.main.async(execute: {
                    completion?(error)
                })
            }
            
            self.removeSaveNotifications(for: context)
        }
    }
}

// MARK: - Private

private extension CoreDataStack {
    func backgroundContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        
        addSaveNotifications(for: context)
        
        return context
    }
    
    func addSaveNotifications(for context: NSManagedObjectContext) {
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: context)
    }
    
    func removeSaveNotifications(for context: NSManagedObjectContext) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSManagedObjectContextDidSave, object: context)
    }
    
    @objc func contextDidSave(_ notification: Notification) {
        //TODO: - This may be overkill, but for now this should fault any objects that wouldn't normally get noticed by FRCs
        //        https://medium.com/bpxl-craft/nsfetchedresultscontroller-woes-3a9b485058#.du7vy78so
        let objects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject> ?? []
        
        mainContext.performAndWait { [weak self] in
            objects.forEach { object in
                let contextualObject = self?.mainContext.object(with: object.objectID)
                contextualObject?.willAccessValue(forKey: nil)
            }
            
            self?.mainContext.mergeChanges(fromContextDidSave: notification)
        }
    }
}

// MARK: - NSManagedObjectModel

extension NSManagedObjectModel {
    static func managedObjectModel(name: String, bundle: Bundle) -> NSManagedObjectModel {
        let URL = bundle.url(forResource: name, withExtension: "momd") ?? bundle.url(forResource: name, withExtension: "mom")
        
        guard let modelURL = URL else {
            preconditionFailure("Could not find resource \(name).momd or \(name).mom for path \(URL)")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            preconditionFailure("Could not create managed object model for name \(name)")
        }
        
        return managedObjectModel
    }
}

// MARK: - NSPersistentStoreCoordinator

extension NSPersistentStoreCoordinator {
    static func persistentStoreCoordinator(managedObjectModel: NSManagedObjectModel, storeType: String, storeURL: URL, options: [AnyHashable: Any]) -> NSPersistentStoreCoordinator {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: storeType, configurationName: nil, at: storeURL, options: options)
        }
        catch let error {
            do {
                try FileManager.default.removeItem(at: storeURL)
                try persistentStoreCoordinator.addPersistentStore(ofType: storeType, configurationName: nil, at: storeURL, options: options)
            }
            catch let removeError {
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
        
        performAndWait {
            if self.hasChanges {
                do {
                    try self.save()
                }
                catch let saveError as NSError {
                    error = saveError
                }
            }
        }
        
        return error
    }
}
