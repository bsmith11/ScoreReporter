//
//  Round.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 4/2/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation

public enum RoundType: Int {
    case pools
    case clusters
    case brackets
    
    public var title: String {
        switch self {
        case .pools:
            return "Pools"
        case .clusters:
            return "Crossovers"
        case .brackets:
            return "Bracket"
        }
    }
}

public struct Round {
    public let id: Int
    public let type: RoundType
    public let group: Group
    public let pools: Set<Pool>
    public let brackets: Set<Bracket>
    public let clusters: Set<Cluster>
    
    public init?(round: ManagedRound) {
        guard let group = round.group.flatMap({ Group(group: $0) }) else {
            return nil
        }
        
        self.id = round.roundID.intValue
        self.group = group
        
        let managedPools = round.pools as? Set<ManagedPool> ?? []
        self.pools = Set(managedPools.flatMap { Pool(pool: $0) })
        
        let managedBrackets = round.brackets as? Set<ManagedBracket> ?? []
        self.brackets = Set(managedBrackets.flatMap { Bracket(bracket: $0) })
        
        let managedClusters = round.clusters as? Set<ManagedCluster> ?? []
        self.clusters = Set(managedClusters.flatMap { Cluster(cluster: $0) })
        
        if self.pools.count > 0 {
            type = .pools
        }
        else if self.clusters.count > 0 {
            type = .clusters
        }
        else {
            type = .brackets
        }
    }
}

// MARK: - Hashable

extension Round: Hashable {
    public var hashValue: Int {
        return id
    }
    
    public static func == (lhs: Round, rhs: Round) -> Bool {
        return lhs.id == rhs.id
    }
}
