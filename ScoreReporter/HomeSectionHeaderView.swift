//
//  HomeSectionHeaderView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

class HomeSectionHeaderView: UITableViewHeaderFooterView {
    private let titleLabel = UILabel(frame: .zero)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.whiteColor()
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension HomeSectionHeaderView {
    func configureWithTitle(title: String?) {
        titleLabel.text = title
    }
}

// MARK: - Private

private extension HomeSectionHeaderView {
    func configureViews() {
        titleLabel.font = UIFont.systemFontOfSize(28.0, weight: UIFontWeightBlack)
        titleLabel.textColor = UIColor.USAUNavyColor()
        contentView.addSubview(titleLabel)
    }
    
    func configureLayout() {
        titleLabel.verticalAnchors == contentView.verticalAnchors + 8.0
        titleLabel.horizontalAnchors == contentView.horizontalAnchors + 16.0
//        titleLabel.edgeAnchors == contentView.edgeAnchors + 16.0
    }
}
