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
    @objc optional func didSelectSectionHeader(_ headerView: SectionHeaderReusableView)
    @objc optional func headerViewDidSelectActionButton(_ headerView: SectionHeaderReusableView)
}

class SectionHeaderReusableView: UICollectionReusableView {
    fileprivate let titleLabel = UILabel(frame: .zero)
    fileprivate let actionButton = UIButton(type: .system)
    
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
    func configureWithTitle(_ title: String?, actionButtonImage: UIImage? = nil) {
        titleLabel.text = title
        
        actionButton.setImage(actionButtonImage, for: UIControlState())
        actionButtonWidth?.isActive = actionButtonImage == nil
    }
    
    class func heightWithTitle(_ title: String?, actionButtonImage: UIImage? = nil) -> CGFloat {
        let titleHeight = UIFont.systemFont(ofSize: 32.0, weight: UIFontWeightBlack).lineHeight + 16.0
        
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
        
        actionButton.tintColor = UIColor.USAURedColor()
        actionButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        actionButton.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
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
