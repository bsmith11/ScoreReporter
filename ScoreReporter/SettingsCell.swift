//
//  SettingsCell.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 10/4/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import ScoreReporterCore

class SettingsCell: TableViewCell {
    fileprivate let contentStackView = UIStackView(frame: .zero)
    fileprivate let iconImageView = UIImageView(frame: .zero)
//    fileprivate let avatarContainerView = UIView(frame: .zero)
//    fileprivate let avatarLabel = UILabel(frame: .zero)
    fileprivate let titleLabel = UILabel(frame: .zero)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        configureViews()
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension SettingsCell {
    func configure(with item: SettingsItem?) {
        iconImageView.image = item?.image
        iconImageView.isHidden = iconImageView.image == nil
        titleLabel.text = item?.title
    }

    func configure(with title: String?) {
        iconImageView.isHidden = true
        titleLabel.text = title
    }
}

// MARK: - Private

private extension SettingsCell {
    func configureViews() {
        contentStackView.axis = .horizontal
        contentStackView.spacing = 16.0
        contentStackView.alignment = .center
        contentView.addSubview(contentStackView)

//        iconImageView.contentMode = .center
//        iconImageView.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
//        contentStackView.addArrangedSubview(iconImageView)
        
//        avatarContainerView.layer.cornerRadius = 8.0
//        avatarContainerView.layer.masksToBounds = true
//        avatarContainerView.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
//        contentStackView.addArrangedSubview(avatarContainerView)

//        avatarLabel.font = UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightBlack)
//        avatarLabel.textColor = UIColor.white
//        avatarLabel.numberOfLines = 1
//        avatarLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
//        avatarContainerView.addSubview(avatarLabel)

        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightBlack)
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        contentStackView.addArrangedSubview(titleLabel)
    }

    func configureLayout() {
        contentStackView.edgeAnchors == contentView.edgeAnchors + 16.0

//        avatarContainerView.heightAnchor == 45.0
//        avatarContainerView.widthAnchor == 45.0

//        avatarLabel.centerAnchors == avatarContainerView.centerAnchors
    }
}
