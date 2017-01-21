//
//  TodayEmptyCell.swift
//  ScoreReporter
//
//  Created by Brad Smith on 1/19/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import ScoreReporterCore

public class TodayEmptyCell: TableViewCell {
    fileprivate let titleLabel = UILabel(frame: .zero)
    
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

public extension TodayEmptyCell {
    func configure(with title: String) {
        titleLabel.text = title
    }
}

// MARK: - Private

private extension TodayEmptyCell {
    func configureViews() {
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightRegular)
        titleLabel.textColor = UIColor.gray
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(titleLabel)
    }
    
    func configureLayout() {
        titleLabel.edgeAnchors == contentView.edgeAnchors + 16.0
    }
}
