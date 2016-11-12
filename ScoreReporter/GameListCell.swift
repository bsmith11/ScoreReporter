//
//  GameListCell.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/25/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

class GameListCell: UITableViewCell {
    fileprivate let contentStackView = UIStackView(frame: .zero)
    fileprivate let homeStackView = UIStackView(frame: .zero)
    fileprivate let homeNameLabel = UILabel(frame: .zero)
    fileprivate let homeScoreLabel = UILabel(frame: .zero)
    fileprivate let awayStackView = UIStackView(frame: .zero)
    fileprivate let awayNameLabel = UILabel(frame: .zero)
    fileprivate let awayScoreLabel = UILabel(frame: .zero)
    fileprivate let infoStackView = UIStackView(frame: .zero)
    fileprivate let fieldLabel = UILabel(frame: .zero)
    fileprivate let statusLabel = UILabel(frame: .zero)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.backgroundColor = UIColor.white
        preservesSuperviewLayoutMargins = false
        layoutMargins = UIEdgeInsets.zero
        separatorInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension GameListCell {
    func configure(with viewModel: GameViewModel) {
        homeNameLabel.attributedText = viewModel.homeTeamName
        homeScoreLabel.attributedText = viewModel.homeTeamScore
        
        awayNameLabel.attributedText = viewModel.awayTeamName
        awayScoreLabel.attributedText = viewModel.awayTeamScore
        
        fieldLabel.text = viewModel.fieldName
        statusLabel.text = viewModel.status
    }
}

// MARK: - Private

private extension GameListCell {
    func configureViews() {
        contentStackView.axis = .vertical
        contentStackView.spacing = 4.0
        contentView.addSubview(contentStackView)
        
        homeStackView.axis = .horizontal
        homeStackView.spacing = 16.0
        contentStackView.addArrangedSubview(homeStackView)
        
        homeNameLabel.textColor = UIColor.USAUNavyColor()
        homeStackView.addArrangedSubview(homeNameLabel)
        
        homeScoreLabel.textColor = UIColor.USAUNavyColor()
        homeScoreLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        homeStackView.addArrangedSubview(homeScoreLabel)
        
        awayStackView.axis = .horizontal
        awayStackView.spacing = 16.0
        contentStackView.addArrangedSubview(awayStackView)
        
        awayNameLabel.textColor = UIColor.USAUNavyColor()
        awayStackView.addArrangedSubview(awayNameLabel)
        
        awayScoreLabel.textColor = UIColor.USAUNavyColor()
        awayScoreLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        awayStackView.addArrangedSubview(awayScoreLabel)
        
        infoStackView.axis = .horizontal
        infoStackView.spacing = 16.0
        contentStackView.addArrangedSubview(infoStackView)
        
        fieldLabel.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightThin)
        fieldLabel.textColor = UIColor.lightGray
        infoStackView.addArrangedSubview(fieldLabel)
        
        statusLabel.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightThin)
        statusLabel.textColor = UIColor.lightGray
        statusLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        infoStackView.addArrangedSubview(statusLabel)
    }
    
    func configureLayout() {
        contentStackView.edgeAnchors == contentView.edgeAnchors + 16.0
    }
}
