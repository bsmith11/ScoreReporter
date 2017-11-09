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
import EZDataSource

class PoolSection: Section<StandingViewModel> {
    let viewModel: PoolViewModel

    init(viewModel: PoolViewModel) {
        self.viewModel = viewModel

        let headerTitle = viewModel.name
        let items = viewModel.standings.flatMap { StandingViewModel(standing: $0) }.sorted { (lhs, rhs) -> Bool in
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
    typealias ItemType = StandingViewModel
    typealias SectionType = PoolSection

    fileprivate let fetchedResultsController: NSFetchedResultsController<Pool>

    fileprivate(set) var sections = [PoolSection]()

    fileprivate(set) dynamic var empty = false
    
    var reloadBlock: ReloadBlock?

    init(viewModel: GroupViewModel) {
        fetchedResultsController = Pool.fetchedPoolsForGroup(withId: viewModel.groupID)

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
    func viewModel(for section: Int) -> PoolViewModel? {
        guard section < sections.count else {
            return nil
        }

        return sections[section].viewModel
    }
}

// MARK: - Private

private extension PoolListDataSource {
    func configureSections() {
        sections.removeAll()
        
        if let pools = fetchedResultsController.fetchedObjects {
            let poolSections = pools.flatMap { PoolViewModel(pool: $0) }.map { PoolSection(viewModel: $0) }
            sections.append(contentsOf: poolSections)
        }
        
        empty = sections.isEmpty
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension PoolListDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        configureSections()
        reloadBlock?(.all)
    }
}
