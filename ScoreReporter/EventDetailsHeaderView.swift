//
//  EventDetailsHeaderView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/25/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import ScoreReporterCore
import Anchorage

class EventDetailsHeaderView: UIView, Sizable {
    fileprivate let backgroundImageView = UIImageView(frame: .zero)
    fileprivate let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    fileprivate let infoStackView = UIStackView(frame: .zero)
    fileprivate let titleLabel = UILabel(frame: .zero)
    fileprivate let subtitleLabel = UILabel(frame: .zero)
    
    fileprivate var backgroundImageViewTop: NSLayoutConstraint?
    fileprivate var animator: UIViewPropertyAnimator?
    
    var fractionComplete: CGFloat {
        get {
            return animator?.fractionComplete ?? 0.0
        }
        
        set {
            animator?.fractionComplete = newValue
        }
    }
    
    var verticalOffset: CGFloat {
        get {
            return backgroundImageViewTop?.constant ?? 0.0
        }
        
        set {
            let offset = min(0.0, newValue)
            let currentOffset = backgroundImageViewTop?.constant ?? 0.0
            
            if !offset.isEqual(to: currentOffset) {
                backgroundImageViewTop?.constant = offset
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = false
        
        configureViews()
        configureLayout()
        
        animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: { [weak self] in
            self?.visualEffectView.effect = nil
            self?.titleLabel.alpha = 0.0
            self?.subtitleLabel.alpha = 0.0
        })
        animator?.fractionComplete = 0.0
        animator?.pauseAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension EventDetailsHeaderView {
    func configure(with event: Event) {
        backgroundImageView.pin_setImage(from: event.searchLogoURL)
        titleLabel.text = event.searchTitle
        subtitleLabel.text = event.searchSubtitle
    }
}

// MARK: - Private

private extension EventDetailsHeaderView {
    func configureViews() {
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        addSubview(backgroundImageView)
        
        addSubview(visualEffectView)
        
        infoStackView.axis = .vertical
        infoStackView.spacing = 0.0
        addSubview(infoStackView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightBlack)
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        infoStackView.addArrangedSubview(titleLabel)
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightRegular)
        subtitleLabel.textColor = UIColor.black
        subtitleLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        infoStackView.addArrangedSubview(subtitleLabel)
    }
    
    func configureLayout() {
        backgroundImageViewTop = backgroundImageView.topAnchor == topAnchor
        backgroundImageView.horizontalAnchors == horizontalAnchors
        backgroundImageView.bottomAnchor == bottomAnchor
        
        visualEffectView.edgeAnchors == backgroundImageView.edgeAnchors
        
        infoStackView.topAnchor == topAnchor + 64.0
        infoStackView.horizontalAnchors == horizontalAnchors + 16.0
        infoStackView.bottomAnchor == bottomAnchor - 16.0
    }
}
