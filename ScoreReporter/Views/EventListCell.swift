//
//  EventListCell.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import pop

class EventListCell: UICollectionViewCell {
    private let contentStackView = UIStackView(frame: .zero)
    private let nameLabel = UILabel(frame: .zero)
    private let locationLabel = UILabel(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureViews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var highlighted: Bool {
        didSet {
            let animation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)

            let scale = highlighted ? 0.9 : 1.0
            animation?.toValue = NSValue(CGSize: CGSize(width: scale, height: scale))

            pop_addAnimation(animation, forKey: "highlighted")
        }
    }

    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let constrainedSize = CGSize(width: layoutAttributes.size.width, height: UILayoutFittingExpandedSize.height)
        let size = CGSize(width: layoutAttributes.size.width, height: systemLayoutSizeFittingSize(constrainedSize).height)

        layoutAttributes.size = size

        return layoutAttributes
    }
}

// MARK: - Public

extension EventListCell {
    func configureWithViewModel(viewModel: EventViewModel) {
        nameLabel.text = viewModel.name
        locationLabel.text = viewModel.location
    }
}

// MARK: - Private

private extension EventListCell {
    func configureViews() {
        contentStackView.axis = .Vertical
        contentView.addSubview(contentStackView)

        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .ByWordWrapping
        nameLabel.font = UIFont.systemFontOfSize(24.0, weight: UIFontWeightLight)
        nameLabel.textColor = UIColor.navyColor()
        contentStackView.addArrangedSubview(nameLabel)

        locationLabel.numberOfLines = 1
        locationLabel.font = UIFont.systemFontOfSize(18.0, weight: UIFontWeightBold)
        locationLabel.textColor = UIColor.navyColor()
        contentStackView.addArrangedSubview(locationLabel)
    }

    func configureLayout() {
        contentStackView.leadingAnchor == contentView.leadingAnchor + 60.0
        contentStackView.trailingAnchor == contentView.trailingAnchor - 10.0
        contentStackView.verticalAnchors == contentView.verticalAnchors + 10.0
    }
}
