//
//  FetchedChangeObject.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/17/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

enum FetchedChangeType: UInt {
    case Insert = 1
    case Delete
    case Move
    case Update
}

enum FetchedChange {
    case Section(type: FetchedChangeType, index: Int)
    case Object(type: FetchedChangeType, indexPath: NSIndexPath?, newIndexPath: NSIndexPath?)
}

class FetchedChangeObject: NSObject {
    static var associatedKey = "com.bradsmith.scorereporter.fetchedChangeObjectAssociatedKey"
    
    private var fetchedChanges = [FetchedChange]()
    
    weak var owner: FetchedChangable?
}

// MARK: - NSFetchedResultsControllerDelegate

extension FetchedChangeObject: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        fetchedChanges.removeAll()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        guard let changeType = FetchedChangeType(rawValue: type.rawValue) else {
            return
        }
        
        let sectionChange = FetchedChange.Section(type: changeType, index: sectionIndex)
        fetchedChanges.append(sectionChange)
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        guard let changeType = FetchedChangeType(rawValue: type.rawValue) else {
            return
        }
        
        let objectChange = FetchedChange.Object(type: changeType, indexPath: indexPath, newIndexPath: newIndexPath)
        fetchedChanges.append(objectChange)
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        owner?.empty = controller.fetchedObjects?.isEmpty ?? true
        owner?.fetchedChangeHandler?(fetchedChanges)
    }
}
