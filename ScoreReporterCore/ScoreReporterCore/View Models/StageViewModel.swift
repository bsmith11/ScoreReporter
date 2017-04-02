//
//  StageViewModel.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 4/2/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation

public struct StageViewModel {
    public let stageId: Int
    public let name: String
    public let bracket: ManagedBracket
    public let games: Set<ManagedGame>
    
    public init?(stage: ManagedStage) {
        guard let bracket = stage.bracket else {
            return nil
        }
        
        self.stageId = stage.stageID.intValue
        self.name = stage.name ?? "No Name"
        self.bracket = bracket
        self.games = stage.games as? Set<ManagedGame> ?? []
    }
}
