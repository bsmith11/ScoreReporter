//
//  GameDetailsViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 12/10/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import ScoreReporterCore

typealias GameDetailsCompletion = (Bool) -> Void

class GameDetailsViewModel: NSObject {
    fileprivate let gameService = GameService()
    
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
    func update(with gameUpdate: GameUpdate, completion: GameDetailsCompletion?) {
        loading = true
        
        gameService.update(with: gameUpdate) { [weak self] result in
            guard let sself = self else {
                return
            }
            
            sself.loading = false
            
            switch result {
            case .success:
                completion?(true)
            case .failure(let error):
                sself.error = error
                completion?(false)
            }
        }
    }
}
