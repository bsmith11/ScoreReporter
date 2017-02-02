//
//  GroupDetailsDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/24/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import ScoreReporterCore

class GroupDetailsDataSource: NSObject, ArrayDataSource {
    typealias ModelType = UIViewController

    fileprivate let groupObserver: ManagedObjectObserver

    fileprivate(set) var items = [UIViewController]()

    fileprivate(set) dynamic var empty = false

    let group: Group

    var refreshBlock: RefreshBlock?

    init(group: Group) {
        self.group = group

        groupObserver = ManagedObjectObserver(objects: [group])

        super.init()

        groupObserver.delegate = self

        configureItems()
    }
}

// MARK: - Private

private extension GroupDetailsDataSource {
    func configureItems() {
        items.removeAll()

        let rounds = group.rounds.allObjects as? [Round]
        let sortedRounds = rounds.flatMap { $0 }?.sorted(by: { $0.0.type.rawValue < $0.1.type.rawValue }) ?? []

        var poolsViewController: UIViewController?
        var bracketsViewController: UIViewController?

        var clusters = [Cluster]()

        sortedRounds.forEach { round in
            switch round.type {
            case .pools:
                if poolsViewController == nil {
                    let poolsDataSource = PoolsDataSource(group: group)
                    poolsViewController = PoolsViewController(dataSource: poolsDataSource)
                }
            case .clusters:
                if let clusterObjects = round.clusters.allObjects as? [Cluster] {
                    clusters.append(contentsOf: clusterObjects)
                }
            case .brackets:
                if bracketsViewController == nil {
                    let bracketListDataSource = BracketListDataSource(group: group)
                    bracketsViewController = BracketListViewController(dataSource: bracketListDataSource)
                }
            }
        }

        if let poolsViewController = poolsViewController {
            items.append(poolsViewController)
        }

        if !clusters.isEmpty {
            let gameListDataSource = GameListDataSource(clusters: clusters)
            let gameListViewController = GameListViewController(dataSource: gameListDataSource)
            items.append(gameListViewController)
        }

        if let bracketsViewController = bracketsViewController {
            items.append(bracketsViewController)
        }

        empty = items.isEmpty
    }
}

// MARK: - ManagedObjectObserverDelegate

extension GroupDetailsDataSource: ManagedObjectObserverDelegate {
    func objectsDidChange(_ objects: [NSManagedObject]) {
        configureItems()
        refreshBlock?()
    }
}
