//
//  TeamDetailsHeaderView.swift
//  ScoreReporter
//
//  Created by Brad Smith on 1/17/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import UIKit
import ScoreReporterCore
import Anchorage

class TeamDetailsHeaderView: UIView, Sizable {
    fileprivate let backgroundImageView = UIImageView(frame: .zero)
    fileprivate let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    fileprivate let separatorView = TableViewCellSeparatorView(frame: .zero)
    fileprivate let infoView = TeamDetailsInfoView(frame: .zero)
    
    fileprivate var backgroundImageViewTop: NSLayoutConstraint?
    var backgroundAnimator: UIViewPropertyAnimator?
    
    var fractionComplete: CGFloat = 1.0 {
        didSet {
            let scaledValue = Double(fractionComplete).scaled(from: 0.0 ... 1.0, to: 0.5 ... 1.0, clamp: true)
            backgroundAnimator?.fractionComplete = CGFloat(scaledValue)
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
    
    weak var delegate: EventDetailsHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = false
        
        configureViews()
        configureLayout()
        
        resetBlurAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension TeamDetailsHeaderView {
    func configure(with viewModel: TeamViewModel) {
        backgroundImageView.pin_setImage(from: viewModel.logoURL)
        
        infoView.configure(with: viewModel)
    }
    
    func resetBlurAnimation() {
        backgroundAnimator?.stopAnimation(true)
        
        visualEffectView.effect = UIBlurEffect(style: .light)
        
        backgroundAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: { [weak self] in
            self?.visualEffectView.effect = nil
        })
        
        backgroundAnimator?.startAnimation()
        backgroundAnimator?.pauseAnimation()
        
        fractionComplete = 0.0
    }
}

// MARK: - Private

private extension TeamDetailsHeaderView {
    func configureViews() {
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        addSubview(backgroundImageView)
        
        addSubview(visualEffectView)
        
        addSubview(separatorView)
        
        addSubview(infoView)
    }
    
    func configureLayout() {
        backgroundImageViewTop = backgroundImageView.topAnchor == topAnchor
        backgroundImageView.horizontalAnchors == horizontalAnchors
        backgroundImageView.bottomAnchor == infoView.centerYAnchor
        
        visualEffectView.edgeAnchors == backgroundImageView.edgeAnchors
        
        separatorView.horizontalAnchors == backgroundImageView.horizontalAnchors
        separatorView.bottomAnchor == backgroundImageView.bottomAnchor
        
        infoView.topAnchor == topAnchor + 96.0
        infoView.horizontalAnchors == horizontalAnchors + 16.0
        infoView.bottomAnchor == bottomAnchor - 16.0
    }
}
