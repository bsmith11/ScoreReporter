//
//  Cluster.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 4/2/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation

public struct Cluster {
    public let id: Int
    public let name: String
    public let round: Round
    public let games: Set<Game>
    
    public init?(cluster: ManagedCluster) {
        guard let round = cluster.round.flatMap({ Round(round: $0) }) else {
            return nil
        }
        
        self.id = cluster.clusterID.intValue
        self.name = cluster.name ?? "No Name"
        self.round = round
        
        let managedGames = cluster.games as? Set<ManagedGame> ?? []
        self.games = Set(managedGames.flatMap { Game(game: $0) })
    }
}

// MARK: - Hashable

extension Cluster: Hashable {
    public var hashValue: Int {
        return id
    }
    
    public static func == (lhs: Cluster, rhs: Cluster) -> Bool {
        return lhs.id == rhs.id
    }
}
