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
    case insert = 1
    case delete
    case move
    case update
}

enum FetchedChange {
    case section(type: FetchedChangeType, index: Int)
    case object(type: FetchedChangeType, indexPath: IndexPath?, newIndexPath: IndexPath?)
}

class FetchedChangeObject: NSObject {
    static var associatedKey = "com.bradsmith.scorereporter.fetchedChangeObjectAssociatedKey"
    
    fileprivate var fetchedChanges = [FetchedChange]()
    
    weak var owner: FetchedChangable?
}

// MARK: - NSFetchedResultsControllerDelegate

extension FetchedChangeObject: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        fetchedChanges.removeAll()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        guard let changeType = FetchedChangeType(rawValue: type.rawValue) else {
            return
        }
        
        let sectionChange = FetchedChange.section(type: changeType, index: sectionIndex)
        fetchedChanges.append(sectionChange)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let changeType = FetchedChangeType(rawValue: type.rawValue) else {
            return
        }
        
        let objectChange = FetchedChange.object(type: changeType, indexPath: indexPath, newIndexPath: newIndexPath)
        fetchedChanges.append(objectChange)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        owner?.empty = controller.fetchedObjects?.isEmpty ?? true
        owner?.fetchedChangeHandler?(fetchedChanges)
    }
}
