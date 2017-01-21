//
//  SectionHeaderView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/24/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

@objc public protocol SectionHeaderViewDelegate: class {
    @objc optional func didSelectActionButton(in headerView: SectionHeaderView)
}

public class SectionHeaderView: UITableViewHeaderFooterView {
    fileprivate let titleLabel = UILabel(frame: .zero)
    fileprivate let actionButton = UIButton(type: .system)

    fileprivate var actionButtonWidth: NSLayoutConstraint?
    
    public class var height: CGFloat {
        let fontHeight = UIFont.systemFont(ofSize: 28.0, weight: UIFontWeightBlack).lineHeight
        return fontHeight + 16.0
    }

    public weak var delegate: SectionHeaderViewDelegate?

    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = UIColor.white
        backgroundView = UIView(frame: .zero)

        configureViews()
        configureLayout()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

public extension SectionHeaderView {
    func configure(with title: String?, actionButtonTitle: String? = nil) {
        titleLabel.text = title

        actionButton.setTitle(actionButtonTitle, for: .normal)
        actionButtonWidth?.isActive = actionButtonTitle == nil        
    }
}

// MARK: - Private

private extension SectionHeaderView {
    func configureViews() {
        titleLabel.font = UIFont.systemFont(ofSize: 28.0, weight: UIFontWeightBlack)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.textColor = UIColor.black
        contentView.addSubview(titleLabel)

        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightBlack)
        actionButton.setTitleColor(UIColor.scRed, for: .normal)
        actionButton.titleEdgeInsets.top = 23.0
        actionButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        actionButton.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        actionButton.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        contentView.addSubview(actionButton)
    }

    func configureLayout() {
        titleLabel.topAnchor == contentView.topAnchor + 16.0
        titleLabel.bottomAnchor == contentView.bottomAnchor
        titleLabel.leadingAnchor == contentView.leadingAnchor + 16.0

        actionButton.topAnchor == contentView.topAnchor
        actionButton.leadingAnchor == titleLabel.trailingAnchor + 16.0
        actionButton.trailingAnchor == contentView.trailingAnchor
        actionButton.bottomAnchor == contentView.bottomAnchor
        actionButtonWidth = actionButton.widthAnchor == 0.0
    }

    @objc func actionButtonTapped() {
        delegate?.didSelectActionButton?(in: self)
    }
}
