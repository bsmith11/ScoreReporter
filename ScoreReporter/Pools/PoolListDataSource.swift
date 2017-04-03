//
//  PoolListDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/24/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData
import ScoreReporterCore
import DataSource

class PoolSection: Section<Standing> {
    let pool: Pool

    init(pool: Pool) {
        self.pool = pool

        let headerTitle = pool.name
        let items = pool.standings.sorted { (lhs, rhs) -> Bool in
            if lhs.sortOrder == rhs.sortOrder {
                return lhs.seed < rhs.seed
            }
            else {
                return lhs.sortOrder < rhs.sortOrder
            }
        }
        
        super.init(items: items, headerTitle: headerTitle)
    }
}

class PoolListDataSource: NSObject, SectionedDataSource {
    typealias ModelType = Standing
    typealias SectionType = PoolSection

    fileprivate let fetchedResultsController: NSFetchedResultsController<ManagedPool>

    fileprivate(set) var sections = [PoolSection]()

    fileprivate(set) dynamic var empty = false
    
    var reloadBlock: ReloadBlock?

    init(group: Group) {
        fetchedResultsController = ManagedPool.fetchedPools(forGroup: group)

        super.init()

        fetchedResultsController.delegate = self

        configureSections()
    }

    deinit {
        fetchedResultsController.delegate = nil
    }
}

// MARK: - Public

extension PoolListDataSource {
    func pool(for section: Int) -> Pool? {
        guard section < sections.count else {
            return nil
        }

        return sections[section].pool
    }
}

// MARK: - Private

private extension PoolListDataSource {
    func configureSections() {
        sections.removeAll()
        
        if let managedPools = fetchedResultsController.fetchedObjects {
            let poolSections = managedPools.flatMap { Pool(pool: $0) }.map { PoolSection(pool: $0) }
            sections.append(contentsOf: poolSections)
        }
        
        empty = sections.isEmpty
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension PoolListDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        configureSections()
        reloadBlock?([])
    }
}
