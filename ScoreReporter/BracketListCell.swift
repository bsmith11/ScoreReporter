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
    private let titleLabel = UILabel(frame: .zero)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.whiteColor()
        preservesSuperviewLayoutMargins = false
        layoutMargins = UIEdgeInsetsZero
        separatorInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        accessoryType = .DisclosureIndicator
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension BracketListCell {
    func configureWithTitle(title: String?) {
        titleLabel.text = title
    }
}

// MARK: - Private

private extension BracketListCell {
    func configureViews() {
        titleLabel.font = UIFont.systemFontOfSize(16.0, weight: UIFontWeightLight)
        titleLabel.textColor = UIColor.USAUNavyColor()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .ByWordWrapping
        contentView.addSubview(titleLabel)
    }
    
    func configureLayout() {
        titleLabel.edgeAnchors == contentView.edgeAnchors + 16.0
    }
}
