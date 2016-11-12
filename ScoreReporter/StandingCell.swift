//
//  StandingCell.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/24/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

class StandingCell: UITableViewCell {
    fileprivate let contentStackView = UIStackView(frame: .zero)
    fileprivate let nameLabel = UILabel(frame: .zero)
    fileprivate let resultsLabel = UILabel(frame: .zero)
    
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

extension StandingCell {
    func configure(with standing: Standing?) {
        let name = standing?.teamName ?? "No Name"
        let seed = standing?.seed.flatMap({"(\($0))"})
        nameLabel.text = [name, seed].flatMap({$0}).joined(separator: " ")
        
        let wins = standing?.wins ?? 0
        let losses = standing?.losses ?? 0
        resultsLabel.text = "\(wins) - \(losses)"
    }
}

// MARK: - Private

private extension StandingCell {
    func configureViews() {
        contentStackView.axis = .horizontal
        contentStackView.spacing = 16.0
        contentView.addSubview(contentStackView)
        
        nameLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightLight)
        nameLabel.textColor = UIColor.USAUNavyColor()
        contentStackView.addArrangedSubview(nameLabel)
        
        resultsLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightLight)
        resultsLabel.textColor = UIColor.USAUNavyColor()
        resultsLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        resultsLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        contentStackView.addArrangedSubview(resultsLabel)
    }
    
    func configureLayout() {
        contentStackView.edgeAnchors == contentView.edgeAnchors + 16.0
    }
}
