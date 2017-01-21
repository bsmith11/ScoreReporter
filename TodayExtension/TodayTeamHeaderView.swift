//
//  TodayTeamHeaderView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 1/7/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import UIKit
import ScoreReporterCore
import Anchorage

class TodayTeamHeaderView: UITableViewHeaderFooterView {
    fileprivate let titleLabel = UILabel(frame: .zero)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundView = UIView(frame: .zero)
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension TodayTeamHeaderView {
    func configure(with title: String) {
        titleLabel.text = title
    }
}

// MARK: - Private

private extension TodayTeamHeaderView {
    func configureViews() {
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightHeavy)
        titleLabel.textColor = UIColor.black
        titleLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(titleLabel)
    }
    
    func configureLayout() {
        titleLabel.topAnchor == contentView.topAnchor + 8.0
        titleLabel.horizontalAnchors == contentView.horizontalAnchors + 16.0
        titleLabel.bottomAnchor == contentView.bottomAnchor
    }
}
