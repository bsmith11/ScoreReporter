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

class TodayTeamHeaderView: UIView, Sizable {
    fileprivate let contentStackView = UIStackView(frame: .zero)
    fileprivate let titleLabel = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension TodayTeamHeaderView {
    func configure(with team: Team) {
        titleLabel.text = team.fullName
    }
}

// MARK: - Private

private extension TodayTeamHeaderView {
    func configureViews() {
        contentStackView.axis = .horizontal
        contentStackView.spacing = 16.0
        addSubview(contentStackView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightHeavy)
        titleLabel.textColor = UIColor.black
        titleLabel.lineBreakMode = .byTruncatingTail
        contentStackView.addArrangedSubview(titleLabel)
    }
    
    func configureLayout() {
        contentStackView.horizontalAnchors == horizontalAnchors + 16.0
        contentStackView.verticalAnchors == verticalAnchors + 8.0
    }
}
