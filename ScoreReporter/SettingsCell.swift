//
//  SettingsCell.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 10/4/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

class SettingsCell: UITableViewCell {
    fileprivate let contentStackView = UIStackView(frame: .zero)
    fileprivate let iconImageView = UIImageView(frame: .zero)
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

extension SettingsCell {
    func configureWithItem(_ item: SettingsItem?) {
        iconImageView.image = item?.image
        iconImageView.isHidden = iconImageView.image == nil
        titleLabel.text = item?.title
    }
    
    func configureWithTitle(_ title: String?) {
        iconImageView.image = nil
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
        
        iconImageView.contentMode = .center
        iconImageView.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        contentStackView.addArrangedSubview(iconImageView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightLight)
        titleLabel.textColor = UIColor.USAUNavyColor()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        contentStackView.addArrangedSubview(titleLabel)
    }
    
    func configureLayout() {
        contentStackView.edgeAnchors == contentView.edgeAnchors + 16.0
    }
}
