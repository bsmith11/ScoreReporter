//
//  HomeHeaderView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

class HomeHeaderView: UITableViewHeaderFooterView {
    private let titleLabel = UILabel(frame: .zero)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.USAURedColor()
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension HomeHeaderView {
    func configureWithTitle(title: String) {
        titleLabel.text = title
    }
    
    func configureWithViewModel(viewModel: EventViewModel) {
        titleLabel.text = viewModel.eventDate
    }
}

// MARK: - Private

private extension HomeHeaderView {
    func configureViews() {
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.systemFontOfSize(14.0, weight: UIFontWeightBold)
        titleLabel.textColor = UIColor.whiteColor()
        contentView.addSubview(titleLabel)
    }
    
    func configureLayout() {
        titleLabel.edgeAnchors == contentView.edgeAnchors + 10.0
    }
}
