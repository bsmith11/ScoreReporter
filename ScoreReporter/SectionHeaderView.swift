//
//  SectionHeaderView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/24/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

@objc protocol SectionHeaderViewDelegate: class {
    @objc optional func didSelectSectionHeader(_ headerView: SectionHeaderView)
    @objc optional func headerViewDidSelectActionButton(_ headerView: SectionHeaderView)
}

class SectionHeaderView: UITableViewHeaderFooterView {
    fileprivate let contentStackView = UIStackView(frame: .zero)
    fileprivate let titleContainerView = UIView(frame: .zero)
    fileprivate let titleLabel = UILabel(frame: .zero)
    fileprivate let actionButton = UIButton(type: .system)
    fileprivate let accessoryImageView = UIImageView(frame: .zero)
//    private let separatorView = UIView(frame: .zero)
    
    weak var delegate: SectionHeaderViewDelegate?
    
//    override var frame: CGRect {
//        didSet {
//            guard let tableView = superview as? UITableView else {
//                return
//            }
//            
//            separatorView.hidden = !(frame.minY <= tableView.contentOffset.y)
//        }
//    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.white
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.addGestureRecognizer(gesture)
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension SectionHeaderView {
    func configureWithTitle(_ title: String?, actionButtonTitle: String? = nil, actionButtonImage: UIImage? = nil, tappable: Bool = false) {
        titleLabel.text = title
        
        actionButton.setTitle(actionButtonTitle, for: UIControlState())
        actionButton.setImage(actionButtonImage, for: UIControlState())
        actionButton.isHidden = (actionButton.title(for: UIControlState()) == nil) && (actionButton.image(for: UIControlState()) == nil)
        
        accessoryImageView.isHidden = !tappable
    }
    
    func configureWithViewModel(_ viewModel: EventViewModel) {
        let title = viewModel.eventStartDate
        
        configureWithTitle(title)
    }
}

// MARK: - Private

private extension SectionHeaderView {
    func configureViews() {
        contentStackView.axis = .horizontal
        contentView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(titleContainerView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 32.0, weight: UIFontWeightBlack)
        titleLabel.textColor = UIColor.USAUNavyColor()
        titleContainerView.addSubview(titleLabel)
        
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightRegular)
        actionButton.setTitleColor(UIColor.USAURedColor(), for: UIControlState())
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        actionButton.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
        contentStackView.addArrangedSubview(actionButton)
        
        accessoryImageView.image = UIImage(named: "icn-disclosure-indicator")?.withRenderingMode(.alwaysTemplate)
        accessoryImageView.tintColor = UIColor.USAUNavyColor()
        accessoryImageView.contentMode = .center
        accessoryImageView.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        contentStackView.addArrangedSubview(accessoryImageView)
        
//        separatorView.hidden = true
//        separatorView.backgroundColor = UIColor(hexString: "#C7C7CC")
//        contentView.addSubview(separatorView)
    }
    
    func configureLayout() {
        contentStackView.edgeAnchors == contentView.edgeAnchors

        titleLabel.verticalAnchors == titleContainerView.verticalAnchors + 8.0
        titleLabel.leadingAnchor == titleContainerView.leadingAnchor + 16.0
        titleLabel.trailingAnchor == titleContainerView.trailingAnchor
        
//        separatorView.horizontalAnchors == contentView.horizontalAnchors
//        separatorView.bottomAnchor == contentView.bottomAnchor
//        separatorView.heightAnchor == 1.0 / UIScreen.mainScreen().scale
    }
    
    @objc func handleTap() {
        delegate?.didSelectSectionHeader?(self)
    }
    
    @objc func actionButtonTapped() {
        delegate?.headerViewDidSelectActionButton?(self)
    }
}
