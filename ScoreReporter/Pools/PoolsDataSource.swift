//
//  PoolsDataSource.swift
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

        let headerTitle = pool.name ?? "Pool"
        let items = (pool.standings.allObjects as? [Standing] ?? []).sorted(by: { (lhs, rhs) -> Bool in
            let leftSortOrder = lhs.sortOrder?.intValue ?? 0
            let rightSortOrder = rhs.sortOrder?.intValue ?? 0

            if leftSortOrder == rightSortOrder {
                return lhs.seed?.intValue ?? 0 < rhs.seed?.intValue ?? 0
            }
            else {
                return leftSortOrder < rightSortOrder
            }
        })
        
        super.init(items: items, headerTitle: headerTitle)
    }
}

class PoolsDataSource: NSObject, SectionedDataSource {
    typealias ModelType = Standing
    typealias SectionType = PoolSection

    fileprivate let fetchedResultsController: NSFetchedResultsController<Pool>

    fileprivate(set) var sections = [PoolSection]()

    fileprivate(set) dynamic var empty = false
    
    var reloadBlock: ReloadBlock?

    init(group: Group) {
        fetchedResultsController = Pool.fetchedPoolsFor(group: group)

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
    func pool(for section: Int) -> Pool? {
        guard section < sections.count else {
            return nil
        }

        return sections[section].pool
    }
}

// MARK: - Private

private extension PoolsDataSource {
    func configureSections() {
        let pools = fetchedResultsController.fetchedObjects ?? []
        sections = pools.map { PoolSection(pool: $0) }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension PoolsDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        configureSections()
    }
}
