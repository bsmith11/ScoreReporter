//
//  SectionHeaderView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/24/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

protocol SectionHeaderViewDelegate: class {
    func didSelectSectionHeader(headerView: SectionHeaderView)
}

class SectionHeaderView: UITableViewHeaderFooterView {
    private let contentStackView = UIStackView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let accessoryImageView = UIImageView(frame: .zero)
    private let separatorView = UIView(frame: .zero)
    
    weak var delegate: SectionHeaderViewDelegate?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.whiteColor()
        
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

extension SectionHeaderView {
    func configureWithTitle(title: String?, tappable: Bool = false) {
        titleLabel.text = title
        
        accessoryImageView.hidden = !tappable
    }
    
    func configureWithViewModel(viewModel: EventViewModel) {
        titleLabel.text = viewModel.eventStartDate
        
        accessoryImageView.hidden = true
    }
}

// MARK: - Private

private extension SectionHeaderView {
    func configureViews() {
        contentStackView.axis = .Horizontal
        contentStackView.spacing = 16.0
        contentView.addSubview(contentStackView)
        
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.systemFontOfSize(24.0, weight: UIFontWeightBlack)
        titleLabel.textColor = UIColor.USAUNavyColor()
        contentStackView.addArrangedSubview(titleLabel)
        
        accessoryImageView.image = UIImage(named: "icn-disclosure-indicator")?.imageWithRenderingMode(.AlwaysTemplate)
        accessoryImageView.tintColor = UIColor.USAUNavyColor()
        accessoryImageView.contentMode = .Center
        accessoryImageView.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        contentStackView.addArrangedSubview(accessoryImageView)
        
        separatorView.backgroundColor = UIColor(hexString: "#C7C7CC")
        contentView.addSubview(separatorView)
    }
    
    func configureLayout() {
        contentStackView.verticalAnchors == contentView.verticalAnchors + 8.0
        contentStackView.horizontalAnchors == contentView.horizontalAnchors + 16.0
        
        separatorView.horizontalAnchors == contentView.horizontalAnchors
        separatorView.bottomAnchor == contentView.bottomAnchor
        separatorView.heightAnchor == 1.0 / UIScreen.mainScreen().scale
    }
    
    @objc func handleTap() {
        delegate?.didSelectSectionHeader(self)
    }
}
