//
//  TodayEventCell.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 1/6/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import ScoreReporterCore

public class TodayEventCell: TableViewCell {
    fileprivate let contentStackView = UIStackView(frame: .zero)
    
    fileprivate let dateStackView = UIStackView(frame: .zero)
    fileprivate let monthLabel = UILabel(frame: .zero)
    fileprivate let rangeLabel = UILabel(frame: .zero)
    
    fileprivate let separatorView = UIView(frame: .zero)
    
    fileprivate let infoStackView = UIStackView(frame: .zero)
    fileprivate let titleLabel = UILabel(frame: .zero)
    fileprivate let subtitleLabel = UILabel(frame: .zero)
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
        configureLayout()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

public extension TodayEventCell {
    func configure(withEvent event: Event) {
        let monthDateFormatter = DateFormatter()
        monthDateFormatter.dateFormat = "MMM"
        
        let rangeDateFormatter = DateIntervalFormatter()
        rangeDateFormatter.dateTemplate = "d"
        
        let month = event.startDate.flatMap { monthDateFormatter.string(from: $0) }
        
        var range: String?
        if let from = event.startDate, let to = event.endDate {
            range = rangeDateFormatter.string(from: from, to: to)
        }
        
        monthLabel.text = month
        rangeLabel.text = range
        
        titleLabel.text = event.searchTitle
        subtitleLabel.text = event.searchSubtitle
    }
}

// MARK: - Private

private extension TodayEventCell {
    func configureViews() {
        contentStackView.axis = .horizontal
        contentStackView.alignment = .center
        contentStackView.spacing = 12.0
        contentView.addSubview(contentStackView)
        
        dateStackView.axis = .vertical
        dateStackView.alignment = .center
        dateStackView.spacing = 0.0
        contentStackView.addArrangedSubview(dateStackView)
        
        monthLabel.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightRegular)
        monthLabel.textColor = UIColor.black
        dateStackView.addArrangedSubview(monthLabel)
        
        rangeLabel.font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightThin)
        rangeLabel.textColor = UIColor.black
        dateStackView.addArrangedSubview(rangeLabel)
        
        separatorView.backgroundColor = UIColor.black
        contentStackView.addArrangedSubview(separatorView)
        
        infoStackView.axis = .vertical
        infoStackView.spacing = 0.0
        contentStackView.addArrangedSubview(infoStackView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightBlack)
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        infoStackView.addArrangedSubview(titleLabel)
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightThin)
        subtitleLabel.textColor = UIColor.black
        infoStackView.addArrangedSubview(subtitleLabel)
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(UILayoutPriorityDefaultLow - 1.0, for: .horizontal)
        contentStackView.addArrangedSubview(spacer)
    }
    
    func configureLayout() {
        contentStackView.horizontalAnchors == contentView.horizontalAnchors + 16.0
        contentStackView.verticalAnchors == contentView.verticalAnchors + 8.0
        
        dateStackView.widthAnchor == 40.0
        
        separatorView.widthAnchor == (1.0 / UIScreen.main.scale)
        separatorView.heightAnchor == dateStackView.heightAnchor
    }
}
