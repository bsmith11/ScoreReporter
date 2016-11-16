//
//  SectionHeaderReusableView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/9/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import ScoreReporterCore

@objc protocol SectionHeaderReusableViewDelegate: class {
    @objc optional func headerViewDidSelectActionButton(_ headerView: SectionHeaderReusableView)
}

class SectionHeaderReusableView: UICollectionReusableView {
    fileprivate let titleLabel = UILabel(frame: .zero)
    fileprivate let actionButton = BaselineButton(type: .system)
    
    fileprivate var actionButtonWidth: NSLayoutConstraint?
    
    weak var delegate: SectionHeaderReusableViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.bounds.width, height: UILayoutFittingCompressedSize.height)
        let size = systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        layoutAttributes.bounds.size = size
        
        return layoutAttributes
    }
}

// MARK: - Public

extension SectionHeaderReusableView {
    func configure(with title: String?, actionTitle: String? = nil) {
        titleLabel.text = title
        
        actionButton.setTitle(actionTitle, for: .normal)
        actionButtonWidth?.isActive = actionButton.title(for: .normal) == nil
    }
    
    class func height(with title: String?, actionButtonImage: UIImage? = nil) -> CGFloat {
        let titleHeight = UIFont.systemFont(ofSize: 32.0, weight: UIFontWeightBlack).lineHeight
        
        if let image = actionButtonImage {
            let imageHeight = image.size.height
            return max(titleHeight, imageHeight)
        }
        else {
            return titleHeight
        }
    }
}

// MARK: - Private

private extension SectionHeaderReusableView {
    func configureViews() {
        titleLabel.font = UIFont.systemFont(ofSize: 32.0, weight: UIFontWeightBlack)
        titleLabel.textColor = UIColor.black
        addSubview(titleLabel)
        
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightBlack)
        actionButton.setTitleColor(UIColor.scRed, for: .normal)
        actionButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        actionButton.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        addSubview(actionButton)
    }
    
    func configureLayout() {
        titleLabel.leadingAnchor == leadingAnchor + 16.0
        titleLabel.verticalAnchors == verticalAnchors
        
        actionButton.leadingAnchor == titleLabel.trailingAnchor + 16.0
        actionButton.trailingAnchor == trailingAnchor
        actionButton.heightAnchor == titleLabel.heightAnchor
        actionButton.firstBaselineAnchor == titleLabel.firstBaselineAnchor
        actionButtonWidth = actionButton.widthAnchor == 0.0
    }
    
    @objc func actionButtonTapped() {
        delegate?.headerViewDidSelectActionButton?(self)
    }
}
