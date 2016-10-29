//
//  GameViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/25/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import UIKit

struct GameViewModel {
    let homeTeamName: NSAttributedString
    let homeTeamScore: NSAttributedString?
    let awayTeamName: NSAttributedString
    let awayTeamScore: NSAttributedString?
    let fieldName: String
    let status: String?
    
    private let winnerAttributes = [
        NSFontAttributeName: UIFont.systemFontOfSize(16.0, weight: UIFontWeightBlack)
    ]
    
    private let loserAttributes = [
        NSFontAttributeName: UIFont.systemFontOfSize(16.0, weight: UIFontWeightThin)
    ]
    
    init(game: Game?) {
        var homeAttributes = loserAttributes
        var awayAttributes = loserAttributes
        
        let homeScore = game?.homeTeamScore ?? ""
        let awayScore = game?.awayTeamScore ?? ""
        
        if let status = game?.status where status == "Final" {
            let score1 = Int(homeScore) ?? 0
            let score2 = Int(awayScore) ?? 0
            
            if score1 > score2 {
                homeAttributes = winnerAttributes
                awayAttributes = loserAttributes
            }
            else {
                homeAttributes = loserAttributes
                awayAttributes = winnerAttributes
            }
        }
        
        let homeName = game?.homeTeamName ?? "TBD"
        homeTeamName = NSAttributedString(string: homeName, attributes: homeAttributes)
        homeTeamScore = NSAttributedString(string: homeScore, attributes: homeAttributes)
        
        let awayName = game?.awayTeamName ?? "TBD"
        awayTeamName = NSAttributedString(string: awayName, attributes: awayAttributes)
        awayTeamScore = NSAttributedString(string: awayScore, attributes: awayAttributes)
        
        fieldName = game?.fieldName ?? "TBD"
        status = game?.status
    }
}
