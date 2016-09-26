//
//  GroupDetailsDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/24/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import UIKit

class GroupDetailsDataSource: ArrayDataSource {
    typealias ModelType = UIViewController
    
    private(set) var items: [UIViewController]
    
    let group: Group
    
    init(group: Group) {
        self.group = group
        
        let roundsSet = group.rounds as? Set<Round>
        let rounds = roundsSet.flatMap({Array($0)})?.sort({$0.0.type.rawValue < $0.1.type.rawValue}) ?? []
        
        items = rounds.map({ round -> UIViewController in
            switch round.type {
            case .Pools:
                let poolsDataSource = PoolsDataSource(round: round)
                return PoolsViewController(dataSource: poolsDataSource)
            case .Clusters:
                let cluster = Array(round.clusters as? Set<Cluster> ?? []).first
                let gameListDataSource = GameListDataSource(cluster: cluster!)
                return GameListViewController(dataSource: gameListDataSource)
            case .Brackets:
                let poolsDataSource = PoolsDataSource(round: round)
                return PoolsViewController(dataSource: poolsDataSource)
            }
        })
    }
}
