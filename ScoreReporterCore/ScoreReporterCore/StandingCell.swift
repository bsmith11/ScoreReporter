//
//  StandingCell.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/24/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

public class StandingCell: TableViewCell {
    fileprivate let contentStackView = UIStackView(frame: .zero)
    fileprivate let nameLabel = UILabel(frame: .zero)
    fileprivate let resultsLabel = UILabel(frame: .zero)

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

public extension StandingCell {
    func configure(with standing: Standing?) {
        let name = standing?.teamName ?? "No Name"
        let seed = standing?.seed.flatMap { "(\($0))" }
        nameLabel.text = [name, seed].flatMap { $0 }.joined(separator: " ")

        let wins = standing?.wins ?? 0
        let losses = standing?.losses ?? 0
        resultsLabel.text = "\(wins) - \(losses)"
        
        contentStackView.layoutIfNeeded()
    }
}

// MARK: - Private

private extension StandingCell {
    func configureViews() {
        contentStackView.axis = .horizontal
        contentStackView.spacing = 8.0
        contentView.addSubview(contentStackView)

        nameLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightBlack)
        nameLabel.textColor = UIColor.black
        contentStackView.addArrangedSubview(nameLabel)

        resultsLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightBlack)
        resultsLabel.textColor = UIColor.black
        resultsLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        resultsLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        contentStackView.addArrangedSubview(resultsLabel)
    }

    func configureLayout() {
        contentStackView.edgeAnchors == contentView.edgeAnchors + 16.0
    }
}
