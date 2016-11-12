//
//  SearchCollectionViewCell.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/9/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import PINRemoteImage

class SearchCollectionViewCell: UICollectionViewCell {
    fileprivate let contentStackView = UIStackView(frame: .zero)
    fileprivate let logoImageView = UIImageView(frame: .zero)
    fileprivate let infoStackView = UIStackView(frame: .zero)
    fileprivate let titleLabel = UILabel(frame: .zero)
    fileprivate let subtitleLabel = UILabel(frame: .zero)
    
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
        layoutAttributes.bounds.size = size
        
        return layoutAttributes
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        logoImageView.pin_cancelImageDownload()
    }
}

// MARK: - Public

extension SearchCollectionViewCell {
    func configureWithSearchable(_ searchable: Searchable?) {
        logoImageView.pin_setImage(from: searchable?.searchLogoURL)
        titleLabel.text = searchable?.searchTitle
        subtitleLabel.text = searchable?.searchSubtitle
    }
}

// MARK: - Private

private extension SearchCollectionViewCell {
    func configureViews() {
        contentStackView.axis = .horizontal
        contentStackView.spacing = 16.0
        contentStackView.alignment = .center
        contentView.addSubview(contentStackView)
        
        logoImageView.contentMode = .scaleAspectFit
        contentStackView.addArrangedSubview(logoImageView)
        
        infoStackView.axis = .vertical
        contentStackView.addArrangedSubview(infoStackView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightRegular)
        titleLabel.textColor = UIColor.USAUNavyColor()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        infoStackView.addArrangedSubview(titleLabel)
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightThin)
        subtitleLabel.textColor = UIColor.gray
        infoStackView.addArrangedSubview(subtitleLabel)
    }
    
    func configureLayout() {
        contentStackView.edgeAnchors == contentView.edgeAnchors
        
        logoImageView.heightAnchor == 50.0
        logoImageView.widthAnchor == 50.0
    }
}
