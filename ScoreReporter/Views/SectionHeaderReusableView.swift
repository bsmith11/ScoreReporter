//
//  SectionHeaderReusableView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/9/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

@objc protocol SectionHeaderReusableViewDelegate: class {
    optional func didSelectSectionHeader(headerView: SectionHeaderReusableView)
    optional func headerViewDidSelectActionButton(headerView: SectionHeaderReusableView)
}

class SectionHeaderReusableView: UICollectionReusableView {
    private let titleLabel = UILabel(frame: .zero)
    private let actionButton = UIButton(type: .System)
    
    private var actionButtonWidth: NSLayoutConstraint?
    
    weak var delegate: SectionHeaderReusableViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.bounds.width, height: UILayoutFittingCompressedSize.height)
        let size = systemLayoutSizeFittingSize(targetSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        layoutAttributes.bounds.size = size
        
        return layoutAttributes
    }
}

// MARK: - Public

extension SectionHeaderReusableView {
    func configureWithTitle(title: String?, actionButtonImage: UIImage? = nil) {
        titleLabel.text = title
        
        actionButton.setImage(actionButtonImage, forState: .Normal)
        actionButtonWidth?.active = actionButtonImage == nil
    }
    
    class func heightWithTitle(title: String?, actionButtonImage: UIImage? = nil) -> CGFloat {
        let titleHeight = UIFont.systemFontOfSize(32.0, weight: UIFontWeightBlack).lineHeight + 16.0
        
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
        titleLabel.font = UIFont.systemFontOfSize(32.0, weight: UIFontWeightBlack)
        titleLabel.textColor = UIColor.blackColor()
        addSubview(titleLabel)
        
        actionButton.tintColor = UIColor.USAURedColor()
        actionButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        actionButton.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        actionButton.addTarget(self, action: #selector(actionButtonTapped), forControlEvents: .TouchUpInside)
        addSubview(actionButton)
    }
    
    func configureLayout() {
        titleLabel.leadingAnchor == leadingAnchor + 16.0
        titleLabel.topAnchor == topAnchor + 16.0
        titleLabel.bottomAnchor == bottomAnchor
        
        actionButton.leadingAnchor == titleLabel.trailingAnchor + 16.0
        actionButton.topAnchor >= topAnchor
        actionButton.bottomAnchor == bottomAnchor
        actionButton.trailingAnchor == trailingAnchor
        actionButtonWidth = actionButton.widthAnchor == 0.0
    }
    
    @objc func actionButtonTapped() {
        delegate?.headerViewDidSelectActionButton?(self)
    }
}
