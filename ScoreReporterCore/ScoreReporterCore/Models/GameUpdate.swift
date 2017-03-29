//
//  GameUpdate.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 3/28/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import Foundation

public struct GameUpdate {
    public let gameID: NSNumber
    public let homeTeamScore: String
    public let awayTeamScore: String
    public let gameStatus: String
    
    public init?(dictionary: [String: Any]) {
        guard let gameID = dictionary[APIConstants.Response.Keys.gameID] as? NSNumber,
              let homeTeamScore = dictionary[APIConstants.Response.Keys.homeTeamScore] as? String,
              let awayTeamScore = dictionary[APIConstants.Response.Keys.awayTeamScore] as? String,
              let gameStatus = dictionary[APIConstants.Response.Keys.gameStatus] as? String else {
            return nil
        }
        
        self.gameID = gameID
        self.homeTeamScore = homeTeamScore
        self.awayTeamScore = awayTeamScore
        self.gameStatus = gameStatus
    }
    
    public init(game: Game, homeTeamScore: String, awayTeamScore: String, gameStatus: String) {
        self.gameID = game.gameID
        self.homeTeamScore = homeTeamScore
        self.awayTeamScore = awayTeamScore
        self.gameStatus = gameStatus
    }
}
