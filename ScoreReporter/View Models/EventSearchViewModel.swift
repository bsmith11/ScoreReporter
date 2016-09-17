//
//  EventSearchViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import CoreData

typealias RefreshBlock = () -> Void

class EventSearchViewModel: NSObject, FetchedDataSource {
    typealias ModelType = Event
    
    private(set) var fetchedResultsController = Event.fetchedEvents()
    
    private(set) dynamic var empty = false
    
    var refreshBlock: RefreshBlock?
    
    override init() {
        super.init()
        
        fetchedResultsController.delegate = self
    }
    
    deinit {
        fetchedResultsController.delegate = nil
    }
}

// MARK: - Public

extension EventSearchViewModel {
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
}

// MARK: - NSFetchedResultsControllerDelegate

extension EventSearchViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        empty = controller.fetchedObjects?.isEmpty ?? true
        
        refreshBlock?()
    }
}
