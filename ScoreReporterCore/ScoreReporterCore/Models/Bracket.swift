//
//  Bracket.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 4/2/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation

public struct Bracket {
    public let id: Int
    public let name: String
    public let sortOrder: Int
    public let round: Round
    public let stages: Set<Stage>
    
    public init?(bracket: ManagedBracket) {
        guard let round = bracket.round.flatMap({ Round(round: $0) }) else {
            return nil
        }
        
        self.id = bracket.bracketID.intValue
        self.name = bracket.name ?? "No Name"
        self.sortOrder = bracket.sortOrder?.intValue ?? 0
        self.round = round
        
        let managedStages = bracket.stages as? Set<ManagedStage> ?? []
        self.stages = Set(managedStages.flatMap { Stage(stage: $0) })
    }
}

// MARK: - Hashable

extension Bracket: Hashable {
    public var hashValue: Int {
        return id
    }
    
    public static func == (lhs: Bracket, rhs: Bracket) -> Bool {
        return lhs.id == rhs.id
    }
}
