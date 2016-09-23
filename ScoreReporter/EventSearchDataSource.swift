//
//  EventSearchDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/17/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

class EventSearchDataSource: NSObject, FetchedDataSource {
    typealias ModelType = Event
    
    private(set) var fetchedResultsController = Event.fetchedEvents()
    
    private(set) dynamic var empty = false

    var refreshBlock: RefreshBlock?
    
    override init() {
        super.init()
        
        fetchedResultsController.delegate = self

        empty = fetchedResultsController.fetchedObjects?.isEmpty ?? true
    }
    
    deinit {
        fetchedResultsController.delegate = nil
    }
}

// MARK: - Public

extension EventSearchDataSource {
    func searchWithText(text: String?) {
        let predicate = Event.searchPredicateWithText(text)
        fetchedResultsController.fetchRequest.predicate = predicate
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch let error as NSError {
            print("Failed to fetch events with error: \(error)")
        }
        
        empty = fetchedResultsController.fetchedObjects?.isEmpty ?? true
        
        refreshBlock?()
    }
    
    func titleForSection(section: Int) -> String? {
        guard section < fetchedResultsController.sections?.count else {
            return nil
        }
        
        let indexPath = NSIndexPath(forRow: 0, inSection: section)
        let event = itemAtIndexPath(indexPath)
        let eventViewModel = EventViewModel(event: event)
        
        return eventViewModel.eventStartDate
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension EventSearchDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        empty = controller.fetchedObjects?.isEmpty ?? true
        
        refreshBlock?()
    }
}
