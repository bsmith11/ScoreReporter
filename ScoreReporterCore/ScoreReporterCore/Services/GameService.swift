//
//  GameService.swift
//  ScoreReporterCore
//
//  Created by Bradley Smith on 12/10/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

public struct GameService {
    fileprivate let client: APIClient
    
    public init(client: APIClient) {
        self.client = client
    }
}

// MARK: - Public

public extension GameService {
    func update(with gameUpdate: GameUpdate, completion: DownloadCompletion?) {
        guard let userToken = KeychainService.load(.accessToken) else {
            let error = NSError(type: .invalidUserToken)
            completion?(DownloadResult(error: error))
            return
        }
        
        let parameters: [String: Any] = [
            APIConstants.Path.Keys.function: APIConstants.Path.Values.updateGame,
            APIConstants.Request.Keys.gameID: gameUpdate.gameID,
            APIConstants.Request.Keys.homeScore: gameUpdate.homeTeamScore,
            APIConstants.Request.Keys.awayScore: gameUpdate.awayTeamScore,
            APIConstants.Request.Keys.gameStatus: gameUpdate.gameStatus,
            APIConstants.Request.Keys.userToken: userToken
        ]
        
        client.request(.get, path: "", parameters: parameters) { result in
            switch result {
            case .success(let value):
                self.parseUpdateGame(response: value, completion: completion)
            case .failure(let error):
                completion?(DownloadResult(error: error))
            }
        }
    }
}

// MARK: - Private

private extension GameService {
    func parseUpdateGame(response: [String: Any], completion: DownloadCompletion?) {
        guard let updateDictionary = response[APIConstants.Response.Keys.updatedGameRecord] as? [String: AnyObject],
              let gameUpdate = GameUpdate(dictionary: updateDictionary) else {
            let error = NSError(type: .invalidResponse)
            completion?(DownloadResult(error: error))
            return
        }
        
        Game.update(with: gameUpdate) { error in
            completion?(DownloadResult(error: error))
        }
    }
}

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
