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
//    fileprivate let stackView = UIStackView(frame: .zero)
//    fileprivate let avatarContainerView = UIView(frame: .zero)
//    fileprivate let avatarLabel = UILabel(frame: .zero)
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

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

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
//        let group = viewModel.game?.group
//        let groupViewModel = GroupViewModel(group: group)
//        avatarLabel.text = groupViewModel.divisionIdentifier
//        avatarContainerView.backgroundColor = groupViewModel.divisionColor

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

//        switch viewModel.state {
//        case .Full:
//            infoStackView.isHidden = false
//            avatarContainerView.isHidden = true
//        case .Division:
//            infoStackView.isHidden = true
//            avatarContainerView.isHidden = false
//        case .Minimal:
//            infoStackView.isHidden = true
//            avatarContainerView.isHidden = true
//        }
    }
}

// MARK: - Private

private extension GameCell {
    func configureViews() {
//        stackView.axis = .horizontal
//        stackView.spacing = 8.0
//        stackView.alignment = .center
//        contentView.addSubview(stackView)
//
//        avatarContainerView.layer.cornerRadius = 4.0
//        avatarContainerView.layer.masksToBounds = true
//        avatarContainerView.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
//        stackView.addArrangedSubview(avatarContainerView)
//
//        avatarLabel.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightBlack)
//        avatarLabel.textColor = UIColor.white
//        avatarLabel.numberOfLines = 1
//        avatarLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
//        avatarContainerView.addSubview(avatarLabel)

        contentStackView.axis = .vertical
        contentStackView.spacing = 4.0
        contentView.addSubview(contentStackView)
//        stackView.addArrangedSubview(contentStackView)

        homeStackView.axis = .horizontal
//        homeStackView.spacing = 16.0
        contentStackView.addArrangedSubview(homeStackView)

        homeNameLabel.textColor = UIColor.black
        homeStackView.addArrangedSubview(homeNameLabel)

        homeScoreLabel.textColor = UIColor.black
        homeScoreLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        homeScoreLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        homeStackView.addArrangedSubview(homeScoreLabel)

        awayStackView.axis = .horizontal
//        awayStackView.spacing = 16.0
        contentStackView.addArrangedSubview(awayStackView)

        awayNameLabel.textColor = UIColor.black
        awayStackView.addArrangedSubview(awayNameLabel)

        awayScoreLabel.textColor = UIColor.black
        awayScoreLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        awayScoreLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        awayStackView.addArrangedSubview(awayScoreLabel)

        infoStackView.axis = .horizontal
//        infoStackView.spacing = 16.0
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
//        stackView.edgeAnchors == contentView.edgeAnchors + 16.0
//
//        avatarContainerView.heightAnchor == 25.0
//        avatarContainerView.widthAnchor == 25.0
//
//        avatarLabel.centerAnchors == avatarContainerView.centerAnchors
    }
}
