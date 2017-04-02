//
//  StandingViewModel.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 4/2/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation

public struct StandingViewModel {
    public let teamName: String
    public let seed: Int
    public let wins: Int
    public let losses: Int
    public let sortOrder: Int
    public let pool: Pool
    
    public init?(standing: Standing) {
        guard let pool = standing.pool else {
            return nil
        }
        
        self.teamName = standing.teamName ?? "No Name"
        self.seed = standing.seed?.intValue ?? 0
        self.wins = standing.wins?.intValue ?? 0
        self.losses = standing.losses?.intValue ?? 0
        self.sortOrder = standing.sortOrder?.intValue ?? 0
        self.pool = pool
    }
}
