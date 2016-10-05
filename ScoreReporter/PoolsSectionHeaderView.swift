//
//  PoolsSectionHeaderView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/24/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

protocol PoolsSectionHeaderViewDelegate: class {
    func didSelectSectionHeader(headerView: PoolsSectionHeaderView)
}

class PoolsSectionHeaderView: UITableViewHeaderFooterView {
    private let contentStackView = UIStackView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let accessoryImageView = UIImageView(frame: .zero)
    
    weak var delegate: PoolsSectionHeaderViewDelegate?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.USAURedColor()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.addGestureRecognizer(gesture)
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension PoolsSectionHeaderView {
    func configureWithTitle(title: String?) {
        titleLabel.text = title
    }
}

// MARK: - Private

private extension PoolsSectionHeaderView {
    func configureViews() {
        contentStackView.axis = .Horizontal
        contentStackView.spacing = 16.0
        contentView.addSubview(contentStackView)
        
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.systemFontOfSize(14.0, weight: UIFontWeightBold)
        titleLabel.textColor = UIColor.whiteColor()
        contentStackView.addArrangedSubview(titleLabel)
        
        accessoryImageView.image = UIImage(named: "icn-disclosure-indicator")?.imageWithRenderingMode(.AlwaysTemplate)
        accessoryImageView.tintColor = UIColor.whiteColor()
        accessoryImageView.contentMode = .Center
        accessoryImageView.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        contentStackView.addArrangedSubview(accessoryImageView)
    }
    
    func configureLayout() {
        contentStackView.edgeAnchors == contentView.edgeAnchors + 16.0
    }
    
    @objc func handleTap() {
        delegate?.didSelectSectionHeader(self)
    }
}
