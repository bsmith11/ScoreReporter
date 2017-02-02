//
//  StageCell.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 1/20/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

public class StageCell: TableViewCell {
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

public extension StageCell {
    func configure(with title: String?) {
        titleLabel.text = title
    }
}

// MARK: - Private

private extension StageCell {
    func configureViews() {
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightRegular)
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(titleLabel)
    }
    
    func configureLayout() {
        titleLabel.edgeAnchors == contentView.edgeAnchors + 16.0
    }
}
