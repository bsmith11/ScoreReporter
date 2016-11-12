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
    private let eventInfoView = EventInfoView(frame: .zero)
    private let mapImageView = UIImageView(frame: .zero)
    private let mapButton = UIButton(type: .System)
    
    var eventInfoHidden = false {
        didSet {
            eventInfoView.hidden = eventInfoHidden
        }
    }
    
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
        eventInfoView.configureWithSearchable(viewModel.searchable)
        mapImageView.setMapImageWithCoordinate(viewModel.coordinate)
    }
}

// MARK: - Private

private extension EventDetailsHeaderView {
    func configureViews() {
        addSubview(eventInfoView)
        
        mapImageView.clipsToBounds = true
        mapImageView.contentMode = .ScaleAspectFill
        addSubview(mapImageView)
        
        mapButton.addTarget(self, action: #selector(mapButtonTapped), forControlEvents: .TouchUpInside)
        addSubview(mapButton)
    }
    
    func configureLayout() {
        eventInfoView.topAnchor == topAnchor + 16.0
        eventInfoView.horizontalAnchors == horizontalAnchors + 16.0
        
        mapImageView.heightAnchor == 150.0
        mapImageView.topAnchor == eventInfoView.bottomAnchor + 16.0
        mapImageView.horizontalAnchors == horizontalAnchors
        mapImageView.bottomAnchor == bottomAnchor
        
        mapButton.edgeAnchors == mapImageView.edgeAnchors
    }
    
    @objc func mapButtonTapped() {
        delegate?.headerViewDidSelectMap(self)
    }
}
