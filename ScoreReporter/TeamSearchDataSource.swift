//
//  TeamSearchDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

class TeamSearchDataSource: NSObject, FetchedDataSource {
    typealias ModelType = Team
    
    private(set) var fetchedResultsController = Team.fetchedTeams()
    
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

extension TeamSearchDataSource {
    func searchWithText(text: String?) {
        let predicate = Team.searchPredicateWithText(text)
        fetchedResultsController.fetchRequest.predicate = predicate
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch let error as NSError {
            print("Failed to fetch teams with error: \(error)")
        }
        
        empty = fetchedResultsController.fetchedObjects?.isEmpty ?? true
        
        refreshBlock?()
    }
    
    func titleForSection(section: Int) -> String? {
        guard section < fetchedResultsController.sections?.count else {
            return nil
        }
        
        let indexPath = NSIndexPath(forRow: 0, inSection: section)
        let team = itemAtIndexPath(indexPath)
        let teamViewModel = TeamViewModel(team: team)
        
        return teamViewModel.state
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TeamSearchDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        empty = controller.fetchedObjects?.isEmpty ?? true
        
        refreshBlock?()
    }
}
