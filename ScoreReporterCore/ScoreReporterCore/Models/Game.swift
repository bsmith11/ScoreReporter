//
//  Game.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 4/2/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation
import UIKit

public enum GameContainer {
    case pool(Pool)
    case cluster(Cluster)
    case stage(Stage)
    
    public var name: String {
        switch self {
        case .pool(let pool):
            return pool.name
        case .cluster(let cluster):
            return cluster.name
        case .stage(let stage):
            return stage.name
        }
    }
    
    public var group: Group {
        switch self {
        case .pool(let pool):
            return pool.round.group
        case .cluster(let cluster):
            return cluster.round.group
        case .stage(let stage):
            return stage.bracket.round.group
        }
    }
}

public enum GameStatus: String {
    case scheduled = "Scheduled"
    case inProgress = "In Progress"
    case cancelled = "Cancelled"
    case final = "Final"
    case unknown = "N/A"
    
    public var displayValue: String {
        return rawValue
    }
}

public struct Game {
    public let id: Int
    public let fieldName: String
    public let startDate: Date?
    public let startTime: Date?
    public let startDateTime: Date?
    public let status: GameStatus
    public let sortOrder: Int
    
    public let awayTeamName: String
    public let awayTeamSeed: String
    public let awayTeamScore: String
    
    public let homeTeamName: String
    public let homeTeamSeed: String
    public let homeTeamScore: String
    
    public let container: GameContainer
    public let homeTeam: Team?
    public let awayTeam: Team?
    
    public init?(game: ManagedGame) {
        if let pool = game.pool.flatMap({ Pool(pool: $0) }) {
            container = .pool(pool)
        }
        else if let cluster = game.cluster.flatMap({ Cluster(cluster: $0) }) {
            container = .cluster(cluster)
        }
        else if let stage = game.stage.flatMap({ Stage(stage: $0) }) {
            container = .stage(stage)
        }
        else {
            return nil
        }
        
        self.id = game.gameID.intValue
        self.fieldName = game.fieldName ?? "No Field"
        self.startDate = game.startDate
        self.startTime = game.startTime
        self.startDateTime = game.startDateFull
        self.status = game.status.flatMap { GameStatus(rawValue: $0) } ?? .unknown
        self.sortOrder = game.sortOrder?.intValue ?? 0
        
        self.homeTeamName = game.homeTeamName ?? "TBD"
        self.homeTeamSeed = game.homeTeamSeed ?? "-"
        self.homeTeamScore = game.homeTeamScore ?? "-"
        
        self.awayTeamName = game.awayTeamName ?? "TBD"
        self.awayTeamSeed = game.awayTeamSeed ?? "-"
        self.awayTeamScore = game.awayTeamScore ?? "-"
        
        self.homeTeam = game.homeTeam.flatMap { Team(team: $0) }
        self.awayTeam = game.awayTeam.flatMap { Team(team: $0) }
    }
}

// MARK: - Hashable

extension Game: Hashable {
    public var hashValue: Int {
        return id
    }
    
    public static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.id == rhs.id
    }
}
