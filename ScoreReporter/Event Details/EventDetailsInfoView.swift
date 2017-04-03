//
//  EventDetailsInfoView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/27/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import ScoreReporterCore
import Anchorage

protocol EventDetailsInfoViewDelegate: class {
    func didSelectMaps(in infoView: EventDetailsInfoView)
}

class EventDetailsInfoView: UIView {
    fileprivate let contentStackView = UIStackView(frame: .zero)
    fileprivate let titleLabel = UILabel(frame: .zero)
    fileprivate let locationLabel = UILabel(frame: .zero)
    fileprivate let dateLabel = UILabel(frame: .zero)
    fileprivate let mapsButton = UIButton(type: .system)
    
    weak var delegate: EventDetailsInfoViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        layer.cornerRadius = 8.0
        layer.borderColor = UIColor(red: 0.78, green: 0.78, blue: 0.8, alpha: 1.0).cgColor
        layer.borderWidth = 1.0 / UIScreen.main.scale
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension EventDetailsInfoView {
    func configure(withEvent event: Event) {
        titleLabel.text = event.name
        
        locationLabel.text = event.cityState
        locationLabel.isHidden = locationLabel.text == nil
        
        dateLabel.text = event.dateRange
        dateLabel.isHidden = dateLabel.text == nil
    }
}

// MARK: - Private

private extension EventDetailsInfoView {
    func configureViews() {
        contentStackView.axis = .vertical
        contentStackView.spacing = 12.0
        addSubview(contentStackView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightBlack)
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        contentStackView.addArrangedSubview(titleLabel)
        
        let bottomStackView = UIStackView(frame: .zero)
        bottomStackView.axis = .horizontal
        contentStackView.addArrangedSubview(bottomStackView)
        
        let detailStackView = UIStackView(frame: .zero)
        detailStackView.axis = .vertical
        detailStackView.spacing = 4.0
        bottomStackView.addArrangedSubview(detailStackView)
        
        locationLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightRegular)
        locationLabel.textColor = UIColor.black
        locationLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        detailStackView.addArrangedSubview(locationLabel)
        
        dateLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightRegular)
        dateLabel.textColor = UIColor.black
        dateLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        detailStackView.addArrangedSubview(dateLabel)
        
        let mapsImage = UIImage(named: "icn-map")
        mapsButton.setImage(mapsImage, for: .normal)
        mapsButton.layer.cornerRadius = 8.0
        mapsButton.layer.masksToBounds = true
        mapsButton.addTarget(self, action: #selector(mapsButtonPressed), for: .touchUpInside)
        mapsButton.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        bottomStackView.addArrangedSubview(mapsButton)
    }
    
    func configureLayout() {
        contentStackView.edgeAnchors == edgeAnchors + 16.0
    }
    
    @objc func mapsButtonPressed() {
        delegate?.didSelectMaps(in: self)
    }
}
