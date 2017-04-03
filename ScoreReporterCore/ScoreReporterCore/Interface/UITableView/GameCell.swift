//
//  GameCell.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/13/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

public enum GameViewState {
    case full
    case normal
    case minimal
}

public class GameCell: TableViewCell {
    fileprivate let contentStackView = UIStackView(frame: .zero)
    
    fileprivate let detailStackView = UIStackView(frame: .zero)
    fileprivate let dateLabel = UILabel(frame: .zero)
    fileprivate let stageLabel = UILabel(frame: .zero)
    
    fileprivate let homeStackView = UIStackView(frame: .zero)
    fileprivate let homeNameLabel = UILabel(frame: .zero)
    fileprivate let homeScoreLabel = UILabel(frame: .zero)
    
    fileprivate let awayStackView = UIStackView(frame: .zero)
    fileprivate let awayNameLabel = UILabel(frame: .zero)
    fileprivate let awayScoreLabel = UILabel(frame: .zero)
    
    fileprivate let infoStackView = UIStackView(frame: .zero)
    fileprivate let fieldLabel = UILabel(frame: .zero)
    fileprivate let statusLabel = UILabel(frame: .zero)
    
    fileprivate let winnerAttributes = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightBlack)
    ]

    fileprivate let loserAttributes = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightThin)
    ]

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureViews()
        configureLayout()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

public extension GameCell {
    func configure(withGame game: Game, state: GameViewState) {
        let dateFormatter = DateFormatter.gameStartDateFullFormatter
        dateLabel.text = game.startDateTime.flatMap { dateFormatter.string(from: $0) }
        dateLabel.isHidden = dateLabel.text == nil
        
        stageLabel.text = game.container.name
        stageLabel.isHidden = stageLabel.text == nil
        
        var homeAttributes = loserAttributes
        var awayAttributes = loserAttributes

        let homeScore = game.homeTeamScore
        let awayScore = game.awayTeamScore

        if case .final = game.status {
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
        
        homeNameLabel.attributedText = NSAttributedString(string: game.homeTeamName, attributes: homeAttributes)

        homeScoreLabel.attributedText = NSAttributedString(string: homeScore, attributes: homeAttributes)
        homeScoreLabel.isHidden = homeScoreLabel.attributedText == nil

        awayNameLabel.attributedText = NSAttributedString(string: game.awayTeamName, attributes: awayAttributes)

        awayScoreLabel.attributedText = NSAttributedString(string: awayScore, attributes: awayAttributes)
        awayScoreLabel.isHidden = awayScoreLabel.attributedText == nil

        fieldLabel.text = game.fieldName
        statusLabel.text = game.status.displayValue

        switch state {
        case .full:
            detailStackView.isHidden = false
            infoStackView.isHidden = false
        case .normal:
            detailStackView.isHidden = true
            infoStackView.isHidden = false
        case .minimal:
            detailStackView.isHidden = true
            infoStackView.isHidden = true
        }
        
        contentStackView.layoutIfNeeded()
    }
}

// MARK: - Private

private extension GameCell {
    func configureViews() {
        contentStackView.axis = .vertical
        contentStackView.spacing = 4.0
        contentView.addSubview(contentStackView)
        
        detailStackView.axis = .horizontal
        detailStackView.spacing = 16.0
        contentStackView.addArrangedSubview(detailStackView)
        
        dateLabel.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightThin)
        dateLabel.textColor = UIColor.lightGray
        detailStackView.addArrangedSubview(dateLabel)
        
        stageLabel.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightThin)
        stageLabel.textColor = UIColor.lightGray
        stageLabel.textAlignment = .right
        stageLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        stageLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        detailStackView.addArrangedSubview(stageLabel)

        homeStackView.axis = .horizontal
        homeStackView.spacing = 16.0
        contentStackView.addArrangedSubview(homeStackView)

        homeNameLabel.textColor = UIColor.black
        homeStackView.addArrangedSubview(homeNameLabel)

        homeScoreLabel.textColor = UIColor.black
        homeScoreLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        homeScoreLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        homeStackView.addArrangedSubview(homeScoreLabel)

        awayStackView.axis = .horizontal
        awayStackView.spacing = 16.0
        contentStackView.addArrangedSubview(awayStackView)

        awayNameLabel.textColor = UIColor.black
        awayStackView.addArrangedSubview(awayNameLabel)

        awayScoreLabel.textColor = UIColor.black
        awayScoreLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        awayScoreLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        awayStackView.addArrangedSubview(awayScoreLabel)

        infoStackView.axis = .horizontal
        infoStackView.spacing = 16.0
        contentStackView.addArrangedSubview(infoStackView)

        fieldLabel.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightThin)
        fieldLabel.textColor = UIColor.lightGray
        infoStackView.addArrangedSubview(fieldLabel)

        statusLabel.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightThin)
        statusLabel.textColor = UIColor.lightGray
        statusLabel.textAlignment = .right
        statusLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        statusLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        infoStackView.addArrangedSubview(statusLabel)
    }

    func configureLayout() {
        contentStackView.edgeAnchors == contentView.edgeAnchors + 16.0
    }
}
