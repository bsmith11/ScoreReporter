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
    private let contentStackView = UIStackView(frame: .zero)
    private let nameLabel = UILabel(frame: .zero)
    private let resultsLabel = UILabel(frame: .zero)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        contentView.backgroundColor = UIColor.whiteColor()
        preservesSuperviewLayoutMargins = false
        layoutMargins = UIEdgeInsetsZero
        separatorInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension StandingCell {
    func configureWithStanding(standing: Standing?) {
        let name = standing?.teamName ?? "No Name"
        let seed = standing?.seed.flatMap({"(\($0))"})
        nameLabel.text = [name, seed].flatMap({$0}).joinWithSeparator(" ")
        
        let wins = standing?.wins ?? 0
        let losses = standing?.losses ?? 0
        resultsLabel.text = "\(wins) - \(losses)"
    }
}

// MARK: - Private

private extension StandingCell {
    func configureViews() {
        contentStackView.axis = .Horizontal
        contentStackView.spacing = 10.0
        contentView.addSubview(contentStackView)
        
        nameLabel.font = UIFont.systemFontOfSize(16.0, weight: UIFontWeightLight)
        nameLabel.textColor = UIColor.USAUNavyColor()
        contentStackView.addArrangedSubview(nameLabel)
        
        resultsLabel.font = UIFont.systemFontOfSize(16.0, weight: UIFontWeightLight)
        resultsLabel.textColor = UIColor.USAUNavyColor()
        resultsLabel.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        contentStackView.addArrangedSubview(resultsLabel)
    }
    
    func configureLayout() {
        contentStackView.edgeAnchors == contentView.edgeAnchors + 10.0
    }
}
