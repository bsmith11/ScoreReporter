//
//  GroupDetailsDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/24/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import CoreData
import ScoreReporterCore
import DataSource

class GroupDetailsDataSource: NSObject, ListDataSource {
    typealias ModelType = UIViewController
    
    fileprivate let fetchedResultsController: NSFetchedResultsController<ManagedRound>

    fileprivate(set) var items = [UIViewController]()

    fileprivate(set) dynamic var empty = false

    let group: Group

    var reloadBlock: ReloadBlock?

    init(group: Group) {
        self.group = group
        self.fetchedResultsController = ManagedRound.fetchedRounds(forGroup: group)

        super.init()

        fetchedResultsController.delegate = self

        configureItems()
    }
    
    deinit {
        fetchedResultsController.delegate = nil
    }
}

// MARK: - Private

private extension GroupDetailsDataSource {
    func configureItems() {
        items.removeAll()

        let managedRounds = fetchedResultsController.fetchedObjects ?? []
        let rounds = managedRounds.flatMap { Round(round: $0) }.sorted(by: { $0.0.type.rawValue < $0.1.type.rawValue })

        var poolListViewController: UIViewController?
        var bracketListViewController: UIViewController?

        var clusters = [Cluster]()

        rounds.forEach { round in
            switch round.type {
            case .pools:
                if poolListViewController == nil {
                    let poolListDataSource = PoolListDataSource(group: group)
                    poolListViewController = PoolListViewController(dataSource: poolListDataSource)
                }
            case .clusters:
                clusters.append(contentsOf: round.clusters)
            case .brackets:
                if bracketListViewController == nil {
                    let bracketListDataSource = BracketListDataSource(group: group)
                    bracketListViewController = BracketListViewController(dataSource: bracketListDataSource)
                }
            }
        }

        if let poolListViewController = poolListViewController {
            items.append(poolListViewController)
        }

        if !clusters.isEmpty {
            let gameListDataSource = GameListDataSource(clusters: clusters)
            let gameListViewController = GameListViewController(dataSource: gameListDataSource)
            items.append(gameListViewController)
        }

        if let bracketListViewController = bracketListViewController {
            items.append(bracketListViewController)
        }

        empty = items.isEmpty
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension GroupDetailsDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        configureItems()
        reloadBlock?([])
    }
}
