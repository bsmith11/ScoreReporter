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
    fileprivate let eventInfoView = EventInfoView(frame: .zero)
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.3, animations: {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.97, y: 0.97) : CGAffineTransform.identity
            }) 
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
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.bounds.width, height: UILayoutFittingCompressedSize.height)
        let size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
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
    func configure(with searchable: Searchable?) {
        eventInfoView.configure(with: searchable)
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
