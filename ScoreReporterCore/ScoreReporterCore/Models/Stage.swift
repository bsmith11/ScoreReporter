//
//  Stage.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 4/2/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation

public struct Stage {
    public let id: Int
    public let name: String
    public let bracket: Bracket
    public let games: Set<Game>
    
    public init?(stage: ManagedStage) {
        guard let bracket = stage.bracket.flatMap({ Bracket(bracket: $0) }) else {
            return nil
        }
        
        self.id = stage.stageID.intValue
        self.name = stage.name ?? "No Name"
        self.bracket = bracket
        
        let managedGames = stage.games as? Set<ManagedGame> ?? []
        self.games = Set(managedGames.flatMap { Game(game: $0) })
    }
}

// MARK: - Hashable

extension Stage: Hashable {
    public var hashValue: Int {
        return id
    }
    
    public static func == (lhs: Stage, rhs: Stage) -> Bool {
        return lhs.id == rhs.id
    }
}
