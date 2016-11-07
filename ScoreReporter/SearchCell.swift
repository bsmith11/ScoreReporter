//
//  SearchCell.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/7/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import PINRemoteImage

class SearchCell: UITableViewCell {
    private let contentStackView = UIStackView(frame: .zero)
    private let logoImageView = UIImageView(frame: .zero)
    private let infoStackView = UIStackView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let subtitleLabel = UILabel(frame: .zero)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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

extension SearchCell {
    func configureWithSearchable(searchable: Searchable?) {
        logoImageView.pin_setImageFromURL(searchable?.searchLogoURL)
        titleLabel.text = searchable?.searchTitle
        subtitleLabel.text = searchable?.searchSubtitle
    }
}

// MARK: - Private

private extension SearchCell {
    func configureViews() {
        contentStackView.axis = .Horizontal
        contentStackView.spacing = 16.0
        contentStackView.alignment = .Center
        contentView.addSubview(contentStackView)
        
        logoImageView.contentMode = .ScaleAspectFit
        contentStackView.addArrangedSubview(logoImageView)
        
        infoStackView.axis = .Vertical
        contentStackView.addArrangedSubview(infoStackView)
        
        titleLabel.font = UIFont.systemFontOfSize(16.0, weight: UIFontWeightRegular)
        titleLabel.textColor = UIColor.USAUNavyColor()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .ByWordWrapping
        infoStackView.addArrangedSubview(titleLabel)
        
        subtitleLabel.font = UIFont.systemFontOfSize(14.0, weight: UIFontWeightThin)
        subtitleLabel.textColor = UIColor.grayColor()
        infoStackView.addArrangedSubview(subtitleLabel)
    }
    
    func configureLayout() {
        contentStackView.edgeAnchors == contentView.edgeAnchors + 16.0
        
        logoImageView.heightAnchor == 50.0
        logoImageView.widthAnchor == 50.0
    }
}
