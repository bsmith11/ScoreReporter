//
//  DataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/21/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import CoreData

typealias RefreshBlock = () -> Void

protocol DataSource {
    associatedtype ModelType

    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> ModelType?
}

protocol ArrayDataSource: DataSource {
    var items: [ModelType] { get }
}

extension ArrayDataSource {
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        guard section == 0 else {
            return 0
        }
        
        return items.count
    }
    
    func item(at indexPath: IndexPath) -> ModelType? {
        guard indexPath.section == 0 && indexPath.item < items.count else {
            return nil
        }
        
        return items[indexPath.item]
    }
}

protocol FetchedDataSource: DataSource {
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> { get }
}

extension FetchedDataSource {
    func numberOfSections() -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    func numberOfItems(in section: Int) -> Int {
        guard let sections = fetchedResultsController.sections, section < sections.count else {
            return 0
        }

        return sections[section].numberOfObjects
    }

    func item(at indexPath: IndexPath) -> ModelType? {
        guard fetchedResultsController.contains(indexPath) else {
            return nil
        }
        
        return fetchedResultsController.object(at: indexPath) as? ModelType
    }
}

extension NSFetchedResultsController {
    func contains(_ indexPath: IndexPath) -> Bool {
        guard let sections = sections, indexPath.section < sections.count else {
            return false
        }
        
        return indexPath.item < sections[indexPath.section].numberOfObjects
    }
}
