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
    func numberOfItemsInSection(section: Int) -> Int
    func itemAtIndexPath(indexPath: NSIndexPath) -> ModelType?
}

protocol ArrayDataSource: DataSource {
    var items: [ModelType] { get }
}

extension ArrayDataSource {
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        guard section == 0 else {
            return 0
        }
        
        return items.count
    }
    
    func itemAtIndexPath(indexPath: NSIndexPath) -> ModelType? {
        guard indexPath.section == 0 && indexPath.item < items.count else {
            return nil
        }
        
        return items[indexPath.item]
    }
}

protocol FetchedDataSource: DataSource {
    var fetchedResultsController: NSFetchedResultsController { get }
}

extension FetchedDataSource {
    func numberOfSections() -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    func numberOfItemsInSection(section: Int) -> Int {
        guard let sections = fetchedResultsController.sections where section < sections.count else {
            return 0
        }

        return sections[section].numberOfObjects
    }

    func itemAtIndexPath(indexPath: NSIndexPath) -> ModelType? {
        guard fetchedResultsController.containsIndexPath(indexPath) else {
            return nil
        }
        
        return fetchedResultsController.objectAtIndexPath(indexPath) as? ModelType
    }
}

extension NSFetchedResultsController {
    func containsIndexPath(indexPath: NSIndexPath) -> Bool {
        guard let sections = sections where indexPath.section < sections.count else {
            return false
        }
        
        return indexPath.item < sections[indexPath.section].numberOfObjects
    }
}
