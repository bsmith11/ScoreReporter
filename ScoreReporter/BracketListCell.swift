//
//  BracketListCell.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/26/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

class BracketListCell: UITableViewCell {
    fileprivate let titleLabel = UILabel(frame: .zero)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = UIColor.white
        preservesSuperviewLayoutMargins = false
        layoutMargins = UIEdgeInsets.zero
        separatorInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        accessoryType = .disclosureIndicator

        configureViews()
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension BracketListCell {
    func configure(with title: String?) {
        titleLabel.text = title
    }
}

// MARK: - Private

private extension BracketListCell {
    func configureViews() {
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightLight)
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(titleLabel)
    }

    func configureLayout() {
        titleLabel.edgeAnchors == contentView.edgeAnchors + 16.0
    }
}
