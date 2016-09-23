//
//  EventDetailsInfoCell.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

class EventDetailsInfoCell: UITableViewCell {
    private let contentStackView = UIStackView(frame: .zero)
    private let iconImageView = UIImageView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.whiteColor()
        preservesSuperviewLayoutMargins = false
        layoutMargins = UIEdgeInsetsZero
        separatorInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        accessoryType = .DisclosureIndicator
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension EventDetailsInfoCell {
    func configureWithInfo(info: EventDetailsInfo?) {
        iconImageView.image = info?.image
        iconImageView.hidden = iconImageView.image == nil
        titleLabel.text = info?.title
    }
}

// MARK: - Private

private extension EventDetailsInfoCell {
    func configureViews() {
        contentStackView.axis = .Horizontal
        contentStackView.spacing = 10.0
        contentStackView.alignment = .Center
        contentView.addSubview(contentStackView)
        
        iconImageView.contentMode = .Center
        iconImageView.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        contentStackView.addArrangedSubview(iconImageView)
        
        titleLabel.font = UIFont.systemFontOfSize(16.0, weight: UIFontWeightLight)
        titleLabel.textColor = UIColor.USAUNavyColor()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .ByWordWrapping
        contentStackView.addArrangedSubview(titleLabel)
    }
    
    func configureLayout() {
        contentStackView.edgeAnchors == contentView.edgeAnchors + 10.0
    }
}
