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

// MARK: - ArrayDataSource

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

// MARK: - SectionedDataSource

public protocol SectionedDataSource: DataSource {
    var sections: [DataSourceSection<ModelType>] { get }
    
    func headerTitle(for section: Int) -> String?
    func footerTitle(for section: Int) -> String?
}

public extension SectionedDataSource {
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        guard section < sections.count else {
            return 0
        }
        
        return sections[section].items.count
    }
    
    func item(at indexPath: IndexPath) -> ModelType? {
        guard indexPath.section < sections.count else {
            return nil
        }
        
        let section = sections[indexPath.section]
        
        guard indexPath.item < section.items.count else {
            return nil
        }
        
        return section.items[indexPath.item]
    }
    
    func headerTitle(for section: Int) -> String? {
        guard section < sections.count else {
            return nil
        }
        
        return sections[section].headerTitle
    }
    
    func footerTitle(for section: Int) -> String? {
        guard section < sections.count else {
            return nil
        }
        
        return sections[section].footerTitle
    }
}

// MARK: - DataSourceSection

public struct DataSourceSection<T> {
    public var items: [T]
    public var headerTitle: String?
    public var footerTitle: String?
    
    public init(items: [T], headerTitle: String? = nil, footerTitle: String? = nil) {
        self.items = items
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
    }
}

// MARK: - FetchedDataSource

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
