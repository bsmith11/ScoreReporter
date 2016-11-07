//
//  SearchDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

class SearchDataSource<Model: Searchable>: NSObject, FetchedDataSource {
    typealias ModelType = Model
    
    private let searchDataSourceHelper = SearchDataSourceHelper()
    
    private(set) var fetchedResultsController = Model.searchFetchedResultsController
    
    private(set) dynamic var empty = false
    
    var refreshBlock: RefreshBlock?
    
    override init() {
        super.init()
        
        searchDataSourceHelper.delegate = self
        fetchedResultsController.delegate = searchDataSourceHelper
        
        empty = fetchedResultsController.fetchedObjects?.isEmpty ?? true
    }
    
    deinit {
        fetchedResultsController.delegate = nil
    }
}

// MARK: - Public

extension SearchDataSource {
    func searchWithText(text: String?) {
        let predicate = Model.predicateWithSearchText(text)
        fetchedResultsController.fetchRequest.predicate = predicate
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch let error as NSError {
            print("Failed to fetch Searchables with error: \(error)")
        }
        
        empty = fetchedResultsController.fetchedObjects?.isEmpty ?? true
        
        refreshBlock?()
    }
    
    func titleForSection(section: Int) -> String? {
        guard section < fetchedResultsController.sections?.count else {
            return nil
        }
        
        let indexPath = NSIndexPath(forRow: 0, inSection: section)
        let item = itemAtIndexPath(indexPath)
        
        return item?.searchSectionTitle
    }
}

// MARK: - SearchDataSourceHelperDelegate

extension SearchDataSource: SearchDataSourceHelperDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        empty = controller.fetchedObjects?.isEmpty ?? true
        
        refreshBlock?()
    }
}

// MARK: - SearchDataSourceHelper

protocol SearchDataSourceHelperDelegate: class {
    func controllerDidChangeContent(controller: NSFetchedResultsController)
}

private class SearchDataSourceHelper: NSObject {
    weak var delegate: SearchDataSourceHelperDelegate?
}

extension SearchDataSourceHelper: NSFetchedResultsControllerDelegate {
    @objc func controllerDidChangeContent(controller: NSFetchedResultsController) {
        delegate?.controllerDidChangeContent(controller)
    }
}
