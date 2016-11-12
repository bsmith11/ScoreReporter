//
//  EventInfoView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/11/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import PINRemoteImage

class EventInfoView: UIView {
    private let contentStackView = UIStackView(frame: .zero)
    private let logoImageView = UIImageView(frame: .zero)
    private let infoStackView = UIStackView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let subtitleLabel = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension EventInfoView {
    func configureWithSearchable(searchable: Searchable?) {
        logoImageView.pin_setImageFromURL(searchable?.searchLogoURL)
        titleLabel.text = searchable?.searchTitle
        subtitleLabel.text = searchable?.searchSubtitle
    }
    
    func cancelImageDownload() {
        logoImageView.pin_cancelImageDownload()
    }
}

// MARK: - Private

private extension EventInfoView {
    func configureViews() {
        contentStackView.axis = .Horizontal
        contentStackView.alignment = .Center
        contentStackView.spacing = 8.0
        addSubview(contentStackView)
        
        logoImageView.contentMode = .ScaleAspectFit
        contentStackView.addArrangedSubview(logoImageView)
        
        infoStackView.axis = .Vertical
        infoStackView.spacing = 2.0
        contentStackView.addArrangedSubview(infoStackView)
        
        titleLabel.font = UIFont.systemFontOfSize(16.0, weight: UIFontWeightBlack)
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .ByWordWrapping
        infoStackView.addArrangedSubview(titleLabel)
        
        subtitleLabel.font = UIFont.systemFontOfSize(14.0, weight: UIFontWeightThin)
        subtitleLabel.textColor = UIColor.blackColor()
        infoStackView.addArrangedSubview(subtitleLabel)
    }
    
    func configureLayout() {
        contentStackView.edgeAnchors == edgeAnchors
        
        logoImageView.widthAnchor == 75.0
        logoImageView.heightAnchor == 75.0
    }
}
