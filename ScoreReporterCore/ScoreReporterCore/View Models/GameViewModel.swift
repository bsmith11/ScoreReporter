//
//  GameViewModel.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/25/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import UIKit

public enum GameViewState {
    case full
    case normal
    case minimal
}

public struct GameViewModel {
    public let game: ManagedGame?
    public let startDate: String?
    public let homeTeamName: NSAttributedString
    public let homeTeamScore: NSAttributedString?
    public let awayTeamName: NSAttributedString
    public let awayTeamScore: NSAttributedString?
    public let fieldName: String
    public let status: String?
    public let state: GameViewState

    fileprivate let winnerAttributes = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightBlack)
    ]

    fileprivate let loserAttributes = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightThin)
    ]

    public init(game: ManagedGame?, state: GameViewState = .normal ) {
        self.game = game
        
        let dateFormatter = DateFormatter.gameStartDateFullFormatter
        startDate = game?.startDateFull.flatMap { dateFormatter.string(from: $0) }

        var homeAttributes = loserAttributes
        var awayAttributes = loserAttributes

        let homeScore = game?.homeTeamScore ?? ""
        let awayScore = game?.awayTeamScore ?? ""

        if let status = game?.status, status == "Final" {
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

        self.state = state
    }
}
