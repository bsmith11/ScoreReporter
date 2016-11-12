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
        let roundsSet = group.rounds as? Set<Round>
        let rounds = roundsSet.flatMap({Array($0)})?.sorted(by: {$0.0.type.rawValue < $0.1.type.rawValue}) ?? []
        
        var poolsViewController: UIViewController?
        var bracketsViewController: UIViewController?
        
        var clusters = [UIViewController]()
        
        rounds.forEach { round in
            switch round.type {
            case .pools:
                if poolsViewController == nil {
                    let poolsDataSource = PoolsDataSource(group: group)
                    poolsViewController = PoolsViewController(dataSource: poolsDataSource)
                }
            case .clusters:
                let cluster = Array(round.clusters as? Set<Cluster> ?? []).first
                let gameListDataSource = GameListDataSource(cluster: cluster!)
                clusters.append(GameListViewController(dataSource: gameListDataSource))
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
        
        items.append(contentsOf: clusters)
        
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
