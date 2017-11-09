//
//  FetchedChangable.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/17/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public typealias FetchedChangeHandler = ([FetchedChange]) -> Void

public protocol FetchedChangable: FetchedChangeObjectDelegate {
    associatedtype ItemType: NSManagedObject

    var empty: Bool { get set }
    var fetchedChangeHandler: FetchedChangeHandler? { get set }

    func register(fetchedResultsController: NSFetchedResultsController<ItemType>)
    func unregister(fetchedResultsController: NSFetchedResultsController<ItemType>)
}

// MARK: - Public

public extension FetchedChangable where Self: NSObject {
    func register(fetchedResultsController: NSFetchedResultsController<ItemType>) {
        fetchedResultsController.delegate = fetchedChangeObject
    }

    func unregister(fetchedResultsController: NSFetchedResultsController<ItemType>) {
        fetchedResultsController.delegate = nil
    }
}

// MARK: - Private

private extension FetchedChangable where Self: NSObject {
    var fetchedChangeObject: FetchedChangeObject {
        guard let object = objc_getAssociatedObject(self, &FetchedChangeObject.associatedKey) as? FetchedChangeObject else {
            let object = FetchedChangeObject()
            objc_setAssociatedObject(self, &FetchedChangeObject.associatedKey, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            object.delegate = self

            return object
        }

        return object
    }
}
