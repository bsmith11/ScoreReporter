//
//  HomeEventCell.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import PINRemoteImage

class HomeEventCell: UITableViewCell {
    private let contentStackView = UIStackView(frame: .zero)
    private let logoImageView = UIImageView(frame: .zero)
    private let infoStackView = UIStackView(frame: .zero)
    private let nameLabel = UILabel(frame: .zero)
    private let locationLabel = UILabel(frame: .zero)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.whiteColor()
        preservesSuperviewLayoutMargins = false
        layoutMargins = UIEdgeInsetsZero
        separatorInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        logoImageView.pin_cancelImageDownload()
    }
}

// MARK: - Public

extension HomeEventCell {
    func configureWithViewModel(viewModel: EventViewModel) {
        logoImageView.pin_setImageFromURL(viewModel.logoURL)
        nameLabel.text = viewModel.name
        locationLabel.text = viewModel.location
    }
}

// MARK: - Private

private extension HomeEventCell {
    func configureViews() {
        contentStackView.axis = .Horizontal
        contentStackView.spacing = 16.0
        contentStackView.alignment = .Center
        contentView.addSubview(contentStackView)
        
        logoImageView.contentMode = .ScaleAspectFit
        contentStackView.addArrangedSubview(logoImageView)
        
        infoStackView.axis = .Vertical
        infoStackView.spacing = 4.0
        contentStackView.addArrangedSubview(infoStackView)
        
        nameLabel.font = UIFont.systemFontOfSize(16.0, weight: UIFontWeightLight)
        nameLabel.textColor = UIColor.USAUNavyColor()
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .ByWordWrapping
        infoStackView.addArrangedSubview(nameLabel)
        
        locationLabel.font = UIFont.systemFontOfSize(14.0, weight: UIFontWeightThin)
        locationLabel.textColor = UIColor.grayColor()
        locationLabel.numberOfLines = 1
        infoStackView.addArrangedSubview(locationLabel)
    }
    
    func configureLayout() {
        contentStackView.edgeAnchors == contentView.edgeAnchors + 16.0
        
        logoImageView.heightAnchor == 50.0
        logoImageView.widthAnchor == 50.0
    }
}
