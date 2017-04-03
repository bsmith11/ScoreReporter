//
//  Pool.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 4/2/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation

public struct Pool {
    public let id: Int
    public let name: String
    public let round: Round
    public let games: Set<Game>
    public let standings: Set<Standing>
    
    public init?(pool: ManagedPool) {
        guard let round = pool.round.flatMap({ Round(round: $0) }) else {
            return nil
        }
        
        self.id = pool.poolID.intValue
        self.name = pool.name ?? "Pool"
        self.round = round
        
        let managedGames = pool.games as? Set<ManagedGame> ?? []
        self.games = Set(managedGames.flatMap { Game(game: $0) })
        
        let managedStandings = pool.standings as? Set<ManagedStanding> ?? []
        self.standings = Set(managedStandings.flatMap { Standing(standing: $0) })
    }
}

// MARK: - Hashable

extension Pool: Hashable {
    public var hashValue: Int {
        return id
    }
    
    public static func == (lhs: Pool, rhs: Pool) -> Bool {
        return lhs.id == rhs.id
    }
}
