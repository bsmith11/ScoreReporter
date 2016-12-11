//
//  GameDetailsViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 12/10/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import ScoreReporterCore

class GameDetailsViewModel: NSObject {
    fileprivate let gameService = GameService(client: APIClient.sharedInstance)
    
    let game: Game
    
    fileprivate(set) dynamic var loading = false
    fileprivate(set) dynamic var error: NSError? = nil
    
    init(game: Game) {
        self.game = game
        
        super.init()
    }
}

// MARK: - Public

extension GameDetailsViewModel {
    func update(with gameUpdate: GameUpdate) {
        loading = true
        
        gameService.update(with: gameUpdate) { [weak self] error in
            self?.loading = false
            self?.error = error
        }
    }
}
