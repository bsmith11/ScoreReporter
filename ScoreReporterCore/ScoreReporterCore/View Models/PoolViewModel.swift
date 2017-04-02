//
//  PoolViewModel.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 4/2/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation

public struct PoolViewModel {
    public let poolID: Int
    public let name: String
    
    public let round: Round
    public let games: Set<Game>
    public let standings: Set<Standing>
    
    public init?(pool: Pool) {
        guard let round = pool.round else {
            return nil
        }
        
        self.poolID = pool.poolID.intValue
        self.name = pool.name ?? "Pool"
        
        self.round = round
        self.games = pool.games as? Set<Game> ?? []
        self.standings = pool.standings as? Set<Standing> ?? []
    }
}
