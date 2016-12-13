//
//  GameCell.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/13/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

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
    func configure(with viewModel: GameViewModel) {
        dateLabel.text = viewModel.startDate
        dateLabel.isHidden = dateLabel.text == nil
        
        stageLabel.text = viewModel.game?.stage?.name
        stageLabel.isHidden = stageLabel.text == nil
        
        homeNameLabel.attributedText = viewModel.homeTeamName

        homeScoreLabel.attributedText = viewModel.homeTeamScore
        homeScoreLabel.isHidden = homeScoreLabel.attributedText == nil

        awayNameLabel.attributedText = viewModel.awayTeamName

        awayScoreLabel.attributedText = viewModel.awayTeamScore
        awayScoreLabel.isHidden = awayScoreLabel.attributedText == nil

        fieldLabel.text = viewModel.fieldName
        fieldLabel.isHidden = fieldLabel.text == nil

        statusLabel.text = viewModel.status
        statusLabel.isHidden = statusLabel.text == nil

        switch viewModel.state {
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
