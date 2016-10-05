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
    private let contentStackView = UIStackView(frame: .zero)
    private let homeStackView = UIStackView(frame: .zero)
    private let homeNameLabel = UILabel(frame: .zero)
    private let homeScoreLabel = UILabel(frame: .zero)
    private let awayStackView = UIStackView(frame: .zero)
    private let awayNameLabel = UILabel(frame: .zero)
    private let awayScoreLabel = UILabel(frame: .zero)
    private let infoStackView = UIStackView(frame: .zero)
    private let fieldLabel = UILabel(frame: .zero)
    private let statusLabel = UILabel(frame: .zero)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        contentView.backgroundColor = UIColor.whiteColor()
        preservesSuperviewLayoutMargins = false
        layoutMargins = UIEdgeInsetsZero
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
    func configureWithViewModel(viewModel: GameViewModel) {
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
        contentStackView.axis = .Vertical
        contentStackView.spacing = 4.0
        contentView.addSubview(contentStackView)
        
        homeStackView.axis = .Horizontal
        homeStackView.spacing = 16.0
        contentStackView.addArrangedSubview(homeStackView)
        
        homeNameLabel.textColor = UIColor.USAUNavyColor()
        homeStackView.addArrangedSubview(homeNameLabel)
        
        homeScoreLabel.textColor = UIColor.USAUNavyColor()
        homeScoreLabel.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        homeStackView.addArrangedSubview(homeScoreLabel)
        
        awayStackView.axis = .Horizontal
        awayStackView.spacing = 16.0
        contentStackView.addArrangedSubview(awayStackView)
        
        awayNameLabel.textColor = UIColor.USAUNavyColor()
        awayStackView.addArrangedSubview(awayNameLabel)
        
        awayScoreLabel.textColor = UIColor.USAUNavyColor()
        awayScoreLabel.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        awayStackView.addArrangedSubview(awayScoreLabel)
        
        infoStackView.axis = .Horizontal
        infoStackView.spacing = 16.0
        contentStackView.addArrangedSubview(infoStackView)
        
        fieldLabel.font = UIFont.systemFontOfSize(12.0, weight: UIFontWeightThin)
        fieldLabel.textColor = UIColor.lightGrayColor()
        infoStackView.addArrangedSubview(fieldLabel)
        
        statusLabel.font = UIFont.systemFontOfSize(12.0, weight: UIFontWeightThin)
        statusLabel.textColor = UIColor.lightGrayColor()
        statusLabel.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        infoStackView.addArrangedSubview(statusLabel)
    }
    
    func configureLayout() {
        contentStackView.edgeAnchors == contentView.edgeAnchors + 16.0
    }
}
