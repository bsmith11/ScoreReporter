//
//  TeamSearchCell.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import PINRemoteImage

class TeamSearchCell: UITableViewCell {
    fileprivate let contentStackView = UIStackView(frame: .zero)
    fileprivate let logoImageView = UIImageView(frame: .zero)
    fileprivate let infoStackView = UIStackView(frame: .zero)
    fileprivate let nameLabel = UILabel(frame: .zero)
    fileprivate let locationLabel = UILabel(frame: .zero)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.white
        preservesSuperviewLayoutMargins = false
        layoutMargins = UIEdgeInsets.zero
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

extension TeamSearchCell {
    func configure(with viewModel: TeamViewModel) {
        logoImageView.pin_setImage(from: viewModel.logoURL)
        nameLabel.text = viewModel.name
        locationLabel.text = viewModel.location
    }
}

// MARK: - Private

private extension TeamSearchCell {
    func configureViews() {
        contentStackView.axis = .horizontal
        contentStackView.spacing = 16.0
        contentStackView.alignment = .center
        contentView.addSubview(contentStackView)
        
        logoImageView.contentMode = .scaleAspectFit
        contentStackView.addArrangedSubview(logoImageView)
        
        infoStackView.axis = .vertical
        infoStackView.spacing = 4.0
        contentStackView.addArrangedSubview(infoStackView)
        
        nameLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightLight)
        nameLabel.textColor = UIColor.black
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        infoStackView.addArrangedSubview(nameLabel)
        
        locationLabel.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightThin)
        locationLabel.textColor = UIColor.gray
        locationLabel.numberOfLines = 1
        infoStackView.addArrangedSubview(locationLabel)
    }
    
    func configureLayout() {
        contentStackView.edgeAnchors == contentView.edgeAnchors + 16.0
        
        logoImageView.heightAnchor == 50.0
        logoImageView.widthAnchor == 50.0
    }
}
