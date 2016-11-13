//
//  PoolsDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/24/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

struct PoolSection {
    let pool: Pool
    let title: String
    let standings: [Standing]
    
    init(pool: Pool) {
        self.pool = pool
        
        title = pool.name ?? "Pool"
        standings = (pool.standings.allObjects as? [Standing] ?? []).sorted(by: { (lhs, rhs) -> Bool in
            let leftSortOrder = lhs.sortOrder?.intValue ?? 0
            let rightSortOrder = rhs.sortOrder?.intValue ?? 0
            
            if leftSortOrder == rightSortOrder {
                return lhs.seed?.intValue ?? 0 < rhs.seed?.intValue ?? 0
            }
            else {
                return leftSortOrder < rightSortOrder
            }
        })
    }
}

class PoolsDataSource: NSObject, DataSource {
    typealias ModelType = Standing
    
    fileprivate let fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    
    fileprivate var sections = [PoolSection]()
    
    fileprivate(set) dynamic var empty = false
        
    init(group: Group) {
        fetchedResultsController = Pool.fetchedPoolsForGroup(group)
        
        super.init()
        
        fetchedResultsController.delegate = self
        
        empty = fetchedResultsController.fetchedObjects?.isEmpty ?? true
        configureSections()
    }
    
    deinit {
        fetchedResultsController.delegate = nil
    }
}

// MARK: - Public

extension PoolsDataSource {
    func poolSection(at section: Int) -> PoolSection? {
        guard section < sections.count else {
            return nil
        }
        
        return sections[section]
    }
}

// MARK: - Private

private extension PoolsDataSource {
    func configureSections() {
        let pools = (fetchedResultsController.fetchedObjects as? [Pool]) ?? []
        sections = pools.map { PoolSection(pool: $0) }
    }
}

// MARK: - DataSource

extension PoolsDataSource {
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        guard section < sections.count else {
            return 0
        }
        
        return sections[section].standings.count
    }
    
    func item(at indexPath: IndexPath) -> Standing? {
        guard indexPath.section < sections.count && indexPath.item < sections[indexPath.section].standings.count else {
            return nil
        }
        
        return sections[indexPath.section].standings[indexPath.item]
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension PoolsDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        configureSections()
    }
}
