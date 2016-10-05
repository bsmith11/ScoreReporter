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

class GroupDetailsDataSource: ArrayDataSource {
    typealias ModelType = UIViewController
    
    private let groupObserver: ManagedObjectObserver
    
    private(set) var items = [UIViewController]()
    
    let group: Group
    
    var refreshBlock: RefreshBlock?
    
    init(group: Group) {
        self.group = group
        
        groupObserver = ManagedObjectObserver(objects: [group])
        groupObserver.delegate = self
        
        configureItems()
    }
}

// MARK: - Private

private extension GroupDetailsDataSource {
    func configureItems() {
        let roundsSet = group.rounds as? Set<Round>
        let rounds = roundsSet.flatMap({Array($0)})?.sort({$0.0.type.rawValue < $0.1.type.rawValue}) ?? []
        
        var poolsViewController: UIViewController?
        var clustersViewController: UIViewController?
        var bracketsViewController: UIViewController?
        
        rounds.forEach { round in
            switch round.type {
            case .Pools:
                let poolsDataSource = PoolsDataSource(round: round)
                poolsViewController = PoolsViewController(dataSource: poolsDataSource)
            case .Clusters:
                let cluster = Array(round.clusters as? Set<Cluster> ?? []).first
                let gameListDataSource = GameListDataSource(cluster: cluster!)
                clustersViewController = GameListViewController(dataSource: gameListDataSource)
            case .Brackets:
                if bracketsViewController == nil {
                    let bracketListDataSource = BracketListDataSource(group: group)
                    bracketsViewController = BracketListViewController(dataSource: bracketListDataSource)
                }
            }
        }
        
        items = [
            poolsViewController,
            clustersViewController,
            bracketsViewController
        ].flatMap({$0})
    }
}

// MARK: - ManagedObjectObserverDelegate

extension GroupDetailsDataSource: ManagedObjectObserverDelegate {
    func objectsDidChange(objects: [NSManagedObject]) {
        configureItems()
        refreshBlock?()
    }
}
