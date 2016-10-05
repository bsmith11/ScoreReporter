//
//  ManagedObjectObserver.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/26/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public protocol ManagedObjectObserverDelegate: class {
    func objectsDidChange(objects: [NSManagedObject])
}

public class ManagedObjectObserver {
    private let context: NSManagedObjectContext?
    
    private var objects = Set<NSManagedObject>()
    
    public weak var delegate: ManagedObjectObserverDelegate?
    
    public init(context: NSManagedObjectContext) {
        self.objects = []
        self.context = context
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(contextDidChange(_:)), name: NSManagedObjectContextObjectsDidChangeNotification, object: context)
    }
    
    public init(objects: [NSManagedObject]) {
        self.objects = Set(objects)
        self.context = objects.first?.managedObjectContext
        
        guard let context = context else {
            print("NSManagedObjectContext is nil for the first object, not observing any changes.")
            
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(contextDidChange(_:)), name: NSManagedObjectContextObjectsDidChangeNotification, object: context)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

// MARK: - Public

public extension ManagedObjectObserver {
    func clearObjects() {
        objects.removeAll()
    }
    
    func addObjects(objects: [NSManagedObject]) {
        self.objects.unionInPlace(objects)
    }
}

// MARK: - Private

private extension ManagedObjectObserver {
    @objc func contextDidChange(notification: NSNotification) {
        guard context == notification.object as? NSManagedObjectContext else {
            return
        }
        
        let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject> ?? []
        let refreshedObjects = notification.userInfo?[NSRefreshedObjectsKey] as? Set<NSManagedObject> ?? []
        
        let updated = updatedObjects.intersect(objects)
        let refreshed = refreshedObjects.intersect(objects)
        
        var flaggedObjects = Array(updated)
        flaggedObjects.appendContentsOf(refreshed)
        
        if !flaggedObjects.isEmpty {
            dispatch_async(dispatch_get_main_queue()) {
                self.delegate?.objectsDidChange(flaggedObjects)
            }
        }
    }
}
