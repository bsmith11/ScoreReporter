//
//  DataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/21/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import CoreData

public typealias RefreshBlock = () -> Void

public protocol DataSource {
    associatedtype ModelType

    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> ModelType?
}

public protocol ArrayDataSource: DataSource {
    var items: [ModelType] { get }
}

public extension ArrayDataSource {
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

public protocol FetchedDataSource: DataSource {
    associatedtype ModelType: NSManagedObject
    
    var fetchedResultsController: NSFetchedResultsController<ModelType> { get }
}

public extension FetchedDataSource {
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
        guard fetchedResultsController.contains(indexPath: indexPath) else {
            return nil
        }
        
        return fetchedResultsController.object(at: indexPath)
    }
}

public extension NSFetchedResultsController {
    func contains(indexPath: IndexPath) -> Bool {
        guard let sections = sections, indexPath.section < sections.count else {
            return false
        }
        
        return indexPath.item < sections[indexPath.section].numberOfObjects
    }
}
