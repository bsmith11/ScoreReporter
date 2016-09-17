//
//  EventListHeaderView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

class EventListHeaderView: UICollectionReusableView {
    private let contentStackView = UIStackView(frame: .zero)
    private let monthLabel = UILabel(frame: .zero)
    private let dayLabel = UILabel(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureViews()
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let constrainedSize = CGSize(width: layoutAttributes.size.width, height: UILayoutFittingExpandedSize.height)
        let size = CGSize(width: layoutAttributes.size.width, height: systemLayoutSizeFittingSize(constrainedSize).height)

        layoutAttributes.size = size

        return layoutAttributes
    }
}

// MARK: - Public

extension EventListHeaderView {
    func configureWithViewModel(viewModel: EventViewModel) {
        monthLabel.text = viewModel.startMonth
        dayLabel.text = viewModel.startDay
    }
}

// MARK: - Private

private extension EventListHeaderView {
    func configureViews() {
        contentStackView.axis = .Vertical
        contentStackView.alignment = .Center
        addSubview(contentStackView)

        monthLabel.numberOfLines = 1
        monthLabel.font = UIFont.systemFontOfSize(14.0, weight: UIFontWeightLight)
        monthLabel.textColor = UIColor.USAUNavyColor()
        contentStackView.addArrangedSubview(monthLabel)

        dayLabel.numberOfLines = 1
        dayLabel.font = UIFont.systemFontOfSize(24.0, weight: UIFontWeightLight)
        dayLabel.textColor = UIColor.USAUNavyColor()
        contentStackView.addArrangedSubview(dayLabel)
    }

    func configureLayout() {
        contentStackView.horizontalAnchors == horizontalAnchors
        contentStackView.topAnchor == topAnchor + 10.0
        contentStackView.bottomAnchor == bottomAnchor - 10.0
    }
}
