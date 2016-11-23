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
    func objectsDidChange(_ objects: [NSManagedObject])
}

public class ManagedObjectObserver {
    fileprivate let context: NSManagedObjectContext?

    fileprivate var objects = Set<NSManagedObject>()

    public weak var delegate: ManagedObjectObserverDelegate?

    public init(context: NSManagedObjectContext) {
        self.objects = []
        self.context = context

        NotificationCenter.default.addObserver(self, selector: #selector(contextDidChange(_:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
    }

    public init(objects: [NSManagedObject]) {
        self.objects = Set(objects)
        self.context = objects.first?.managedObjectContext

        guard let context = context else {
            print("NSManagedObjectContext is nil for the first object, not observing any changes.")

            return
        }

        NotificationCenter.default.addObserver(self, selector: #selector(contextDidChange(_:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Public

public extension ManagedObjectObserver {
    func clearObjects() {
        objects.removeAll()
    }

    func addObjects(_ objects: [NSManagedObject]) {
        self.objects.formUnion(objects)
    }
}

// MARK: - Private

private extension ManagedObjectObserver {
    @objc func contextDidChange(_ notification: Notification) {
        guard context == notification.object as? NSManagedObjectContext else {
            return
        }

        let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject> ?? []
        let refreshedObjects = notification.userInfo?[NSRefreshedObjectsKey] as? Set<NSManagedObject> ?? []

        let updated = updatedObjects.intersection(objects)
        let refreshed = refreshedObjects.intersection(objects)

        var flaggedObjects = Array(updated)
        flaggedObjects.append(contentsOf: refreshed)

        if !flaggedObjects.isEmpty {
            DispatchQueue.main.async {
                self.delegate?.objectsDidChange(flaggedObjects)
            }
        }
    }
}
