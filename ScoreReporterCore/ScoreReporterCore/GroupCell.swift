//
//  GroupCell.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/12/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import PINRemoteImage

public class GroupCell: TableViewCell {
    fileprivate let contentStackView = UIStackView(frame: .zero)
    fileprivate let avatarContainerView = UIView(frame: .zero)
    fileprivate let avatarLabel = UILabel(frame: .zero)
    fileprivate let titleLabel = UILabel(frame: .zero)
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        configureViews()
        configureLayout()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

public extension GroupCell {
    func configure(with viewModel: GroupViewModel?) {
        avatarLabel.text = viewModel?.divisionIdentifier
        avatarContainerView.backgroundColor = viewModel?.divisionColor
        titleLabel.text = viewModel?.fullName
    }
}

// MARK: - Private

private extension GroupCell {
    func configureViews() {
        contentStackView.axis = .horizontal
        contentStackView.spacing = 8.0
        contentStackView.alignment = .center
        contentView.addSubview(contentStackView)
        
        avatarContainerView.layer.cornerRadius = 8.0
        avatarContainerView.layer.masksToBounds = true
        avatarContainerView.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        contentStackView.addArrangedSubview(avatarContainerView)
        
        avatarLabel.font = UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightBlack)
        avatarLabel.textColor = UIColor.white
        avatarLabel.numberOfLines = 1
        avatarLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        avatarContainerView.addSubview(avatarLabel)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightBlack)
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        contentStackView.addArrangedSubview(titleLabel)
    }
    
    func configureLayout() {
        contentStackView.edgeAnchors == contentView.edgeAnchors + 16.0
        
        avatarContainerView.heightAnchor == 45.0
        avatarContainerView.widthAnchor == 45.0
        
        avatarLabel.centerAnchors == avatarContainerView.centerAnchors
    }
}
