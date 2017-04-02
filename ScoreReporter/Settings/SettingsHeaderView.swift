//
//  SettingsHeaderView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/23/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import ScoreReporterCore
import Anchorage

class SettingsHeaderView: UIView, Sizable {
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

extension SettingsHeaderView {
    func configure(with user: ManagedUser) {
        titleLabel.text = "USAU ID: \(user.accountID.intValue)"
    }
}

// MARK: - Private

private extension SettingsHeaderView {
    func configureViews() {
        titleLabel.font = UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightBlack)
        titleLabel.textColor = UIColor.black
        titleLabel.lineBreakMode = .byTruncatingTail
        addSubview(titleLabel)
    }
    
    func configureLayout() {
        titleLabel.horizontalAnchors == horizontalAnchors + 16.0
        titleLabel.verticalAnchors == verticalAnchors + 8.0
    }
}
