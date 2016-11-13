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
}

// MARK: - Public

extension EventInfoView {
    func configure(with event: Event?) {
        logoImageView.pin_setImage(from: event?.searchLogoURL)
        titleLabel.text = event?.searchTitle
        subtitleLabel.text = event?.searchSubtitle
    }
    
    func cancelImageDownload() {
        logoImageView.pin_cancelImageDownload()
    }
}

// MARK: - Private

private extension EventInfoView {
    func configureViews() {
        contentStackView.axis = .horizontal
        contentStackView.alignment = .center
        contentStackView.spacing = 8.0
        addSubview(contentStackView)
        
        logoImageView.contentMode = .scaleAspectFit
        contentStackView.addArrangedSubview(logoImageView)
        
        infoStackView.axis = .vertical
        infoStackView.spacing = 2.0
        contentStackView.addArrangedSubview(infoStackView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightBlack)
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        infoStackView.addArrangedSubview(titleLabel)
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightThin)
        subtitleLabel.textColor = UIColor.black
        infoStackView.addArrangedSubview(subtitleLabel)
    }
    
    func configureLayout() {
        contentStackView.edgeAnchors == edgeAnchors
        
        logoImageView.widthAnchor == 55.0
        logoImageView.heightAnchor == 55.0
    }
}
