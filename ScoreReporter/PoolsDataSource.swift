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
        standings = Array((pool.standings as? Set<Standing>) ?? []).sort({ (lhs, rhs) -> Bool in
            let leftSortOrder = lhs.sortOrder?.integerValue ?? 0
            let rightSortOrder = rhs.sortOrder?.integerValue ?? 0
            
            if leftSortOrder == rightSortOrder {
                return lhs.seed?.integerValue < rhs.seed?.integerValue
            }
            else {
                return leftSortOrder < rightSortOrder
            }
        })
    }
}

class PoolsDataSource: NSObject, DataSource {
    typealias ModelType = Standing
    
    private let fetchedResultsController: NSFetchedResultsController
    
    private var sections = [PoolSection]()
    
    private(set) dynamic var empty = false
        
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
    func poolSectionAtSection(section: Int) -> PoolSection? {
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
        sections = pools.map({PoolSection(pool: $0)})
    }
}

// MARK: - DataSource

extension PoolsDataSource {
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        guard section < sections.count else {
            return 0
        }
        
        return sections[section].standings.count
    }
    
    func itemAtIndexPath(indexPath: NSIndexPath) -> Standing? {
        guard indexPath.section < sections.count && indexPath.item < sections[indexPath.section].standings.count else {
            return nil
        }
        
        return sections[indexPath.section].standings[indexPath.item]
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension PoolsDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        configureSections()
    }
}
