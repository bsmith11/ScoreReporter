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
    
    fileprivate let searchDataSourceHelper = SearchDataSourceHelper()
    
    fileprivate(set) var fetchedResultsController = Model.searchFetchedResultsController
    
    fileprivate(set) dynamic var empty = false
    
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
    func search(for text: String?) {
        let predicate = Model.predicate(with: text)
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
    
    func title(for section: Int) -> String? {
        guard section < fetchedResultsController.sections?.count ?? 0 else {
            return nil
        }
        
        let indexPath = IndexPath(row: 0, section: section)
        let item = self.item(at: indexPath)
        
        return item?.searchSectionTitle
    }
}

// MARK: - SearchDataSourceHelperDelegate

extension SearchDataSource: SearchDataSourceHelperDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        empty = controller.fetchedObjects?.isEmpty ?? true
        
        refreshBlock?()
    }
}

// MARK: - SearchDataSourceHelper

protocol SearchDataSourceHelperDelegate: class {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
}

private class SearchDataSourceHelper: NSObject {
    weak var delegate: SearchDataSourceHelperDelegate?
}

extension SearchDataSourceHelper: NSFetchedResultsControllerDelegate {
    @objc func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.controllerDidChangeContent(controller)
    }
}
