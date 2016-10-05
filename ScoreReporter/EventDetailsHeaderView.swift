//
//  EventDetailsHeaderView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/17/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import CoreLocation
import MapSnap

protocol EventDetailsHeaderViewDelegate: class {
    func headerViewDidSelectMap(headerView: EventDetailsHeaderView)
}

class EventDetailsHeaderView: UIView {
    private let infoStackView = UIStackView(frame: .zero)
    private let logoImageView = UIImageView(frame: .zero)
    private let nameLabel = UILabel(frame: .zero)
    private let mapImageView = UIImageView(frame: .zero)
    private let mapButton = UIButton(type: .System)
    
    weak var delegate: EventDetailsHeaderViewDelegate?
    
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

extension EventDetailsHeaderView {
    func configureWithViewModel(viewModel: EventViewModel) {
        logoImageView.pin_setImageFromURL(viewModel.logoURL)
        nameLabel.text = viewModel.name
        mapImageView.setMapImageWithCoordinate(viewModel.coordinate)
    }
}

// MARK: - Private

private extension EventDetailsHeaderView {
    func configureViews() {
        infoStackView.axis = .Horizontal
        infoStackView.spacing = 16.0
        infoStackView.alignment = .Center
        addSubview(infoStackView)
        
        logoImageView.contentMode = .ScaleAspectFit
        infoStackView.addArrangedSubview(logoImageView)
        
        nameLabel.font = UIFont.systemFontOfSize(18.0, weight: UIFontWeightSemibold)
        nameLabel.textColor = UIColor.USAUNavyColor()
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .ByWordWrapping
        infoStackView.addArrangedSubview(nameLabel)
        
        mapImageView.clipsToBounds = true
        mapImageView.contentMode = .ScaleAspectFill
        addSubview(mapImageView)
        
        mapButton.addTarget(self, action: #selector(mapButtonTapped), forControlEvents: .TouchUpInside)
        addSubview(mapButton)
    }
    
    func configureLayout() {
        infoStackView.topAnchor == topAnchor + 16.0
        infoStackView.horizontalAnchors == horizontalAnchors + 16.0
        
        logoImageView.heightAnchor == 50.0
        logoImageView.widthAnchor == 50.0
        
        mapImageView.heightAnchor == 150.0
        mapImageView.topAnchor == infoStackView.bottomAnchor + 16.0
        mapImageView.horizontalAnchors == horizontalAnchors
        mapImageView.bottomAnchor == bottomAnchor
        
        mapButton.edgeAnchors == mapImageView.edgeAnchors
    }
    
    @objc func mapButtonTapped() {
        delegate?.headerViewDidSelectMap(self)
    }
}
