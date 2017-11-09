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
import EZDataSource

class GroupDetailsDataSource: NSObject, ListDataSource {
    typealias ItemType = UIViewController
    
    fileprivate let fetchedResultsController: NSFetchedResultsController<Round>

    fileprivate(set) var items = [UIViewController]()

    fileprivate(set) dynamic var empty = false

    let viewModel: GroupViewModel

    var reloadBlock: ReloadBlock?

    init(viewModel: GroupViewModel) {
        self.viewModel = viewModel
        self.fetchedResultsController = Round.fetchedRoundsForGroup(withId: viewModel.groupID)

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

        let rounds = fetchedResultsController.fetchedObjects ?? []
        let sortedRounds = rounds.sorted(by: { $0.0.type.rawValue < $0.1.type.rawValue })

        var poolListViewController: UIViewController?
        var bracketListViewController: UIViewController?

        var clusters = [Cluster]()

        sortedRounds.forEach { round in
            switch round.type {
            case .pools:
                if poolListViewController == nil {
                    let poolListDataSource = PoolListDataSource(viewModel: viewModel)
                    poolListViewController = PoolListViewController(dataSource: poolListDataSource)
                }
            case .clusters:
                if let clusterObjects = round.clusters.allObjects as? [Cluster] {
                    clusters.append(contentsOf: clusterObjects)
                }
            case .brackets:
                if bracketListViewController == nil {
                    let bracketListDataSource = BracketListDataSource(viewModel: viewModel)
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
        reloadBlock?(.all)
    }
}
