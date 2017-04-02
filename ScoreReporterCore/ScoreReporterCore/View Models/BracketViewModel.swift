//
//  BracketViewModel.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 4/2/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation

public struct BracketViewModel {
    public let bracketId: Int
    public let name: String
    public let sortOrder: Int
    public let round: Round
    public let stages: Set<Stage>
    
    public init?(bracket: Bracket) {
        guard let round = bracket.round else {
            return nil
        }
        
        self.bracketId = bracket.bracketID.intValue
        self.name = bracket.name ?? "No Name"
        self.sortOrder = bracket.sortOrder?.intValue ?? 0
        self.round = round
        self.stages = bracket.stages as? Set<Stage> ?? []
    }
}
