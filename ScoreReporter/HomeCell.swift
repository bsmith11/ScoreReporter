//
//  HomeCell.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/9/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import PINRemoteImage

class HomeCell: UICollectionViewCell {
    private let eventInfoView = EventInfoView(frame: .zero)
    
    override var highlighted: Bool {
        didSet {
            UIView.animateWithDuration(0.3) {
                self.transform = self.highlighted ? CGAffineTransformMakeScale(0.97, 0.97) : CGAffineTransformIdentity
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.bounds.width, height: UILayoutFittingCompressedSize.height)
        let size = contentView.systemLayoutSizeFittingSize(targetSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        
        let attributes = super.preferredLayoutAttributesFittingAttributes(layoutAttributes)
        attributes.bounds.size = size
        
        return attributes
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        eventInfoView.cancelImageDownload()
    }
}

// MARK: - Public

extension HomeCell {
    func configureWithSearchable(searchable: Searchable?) {
        eventInfoView.configureWithSearchable(searchable)
    }
}

// MARK: - Private

private extension HomeCell {
    func configureViews() {
        contentView.addSubview(eventInfoView)
    }
    
    func configureLayout() {
        eventInfoView.edgeAnchors == contentView.edgeAnchors
    }
}
