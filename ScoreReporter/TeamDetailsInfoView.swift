//
//  TeamDetailsInfoView.swift
//  ScoreReporter
//
//  Created by Brad Smith on 1/17/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import UIKit
import ScoreReporterCore
import Anchorage

class TeamDetailsInfoView: UIView {
    fileprivate let contentStackView = UIStackView(frame: .zero)
    fileprivate let nameLabel = UILabel(frame: .zero)
    fileprivate let locationLabel = UILabel(frame: .zero)
    fileprivate let competitionLabel = UILabel(frame: .zero)
    
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

extension TeamDetailsInfoView {
    func configure(with team: Team) {
        let teamViewModel = TeamViewModel(team: team)
        
        nameLabel.text = teamViewModel.fullName
        
        locationLabel.text = teamViewModel.location
        locationLabel.isHidden = locationLabel.text == nil
        
        competitionLabel.text = teamViewModel.competitionDivision
        competitionLabel.isHidden = competitionLabel.text == nil
    }
}

// MARK: - Private

private extension TeamDetailsInfoView {
    func configureViews() {
        contentStackView.axis = .vertical
        contentStackView.spacing = 12.0
        addSubview(contentStackView)
        
        nameLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightBlack)
        nameLabel.textColor = UIColor.black
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        contentStackView.addArrangedSubview(nameLabel)
        
        let detailStackView = UIStackView(frame: .zero)
        detailStackView.axis = .vertical
        detailStackView.spacing = 4.0
        contentStackView.addArrangedSubview(detailStackView)
        
        locationLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightRegular)
        locationLabel.textColor = UIColor.black
        locationLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        detailStackView.addArrangedSubview(locationLabel)
        
        competitionLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightRegular)
        competitionLabel.textColor = UIColor.black
        competitionLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        detailStackView.addArrangedSubview(competitionLabel)
    }
    
    func configureLayout() {
        contentStackView.edgeAnchors == edgeAnchors + 16.0
    }
}
