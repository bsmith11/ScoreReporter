//
//  EmptyView.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 2/10/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

public enum EmptyViewState {
    case none
    case base
    case empty
    case error
}

public class EmptyView: UIView, KeyboardObservable {
    fileprivate let loadingView = EmptyLoadingView(frame: .zero)
    
    fileprivate var contentViews = [EmptyViewState: UIView]()
    fileprivate var bottomConstraint: NSLayoutConstraint?
    
    fileprivate var frameInWindow: CGRect {
        let frameInWindow: CGRect
        
        if let superview = superview {
            frameInWindow = superview.convert(frame, to: nil)
        }
        else {
            frameInWindow = frame
        }
        
        return frameInWindow
    }
    
    fileprivate weak var currentContentView: UIView?
    
    public var state: EmptyViewState = .none {
        didSet {
            if state != oldValue {
                update(withState: state)
            }
        }
    }
    
    public var loading = false {
        didSet {
            if loading != oldValue {
                updateLoadingState()
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSubviews()
        configureLayout()
        
        update(withState: state)
        
        addKeyboardObserver { [weak self] (visible, keyboardFrame) in
            guard let strongSelf = self else {
                return
            }
            
            if visible {
                let delta = strongSelf.frameInWindow.maxY - keyboardFrame.minY
                
                if delta > 0 {
                    strongSelf.bottomConstraint?.constant = -delta
                }
            }
            else {
                strongSelf.bottomConstraint?.constant = 0.0
            }
            
            strongSelf.superview?.layoutIfNeeded()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

public extension EmptyView {
    func set(contentView: UIView?, forState state: EmptyViewState) {
        contentViews[state] = contentView
    }
    
    func contentView(forState state: EmptyViewState) -> UIView? {
        return contentViews[state]
    }
}

// MARK: - Private

private extension EmptyView {
    func configureSubviews() {
        loadingView.tintColor = UIColor.gray
        addSubview(loadingView)
    }
    
    func configureLayout() {
        loadingView.edgeAnchors == edgeAnchors
    }
    
    func update(withState state: EmptyViewState) {
        if let contentView = contentViews[state] {
            currentContentView?.removeFromSuperview()
            currentContentView = contentView
            
            addSubview(contentView)
            contentView.topAnchor == topAnchor
            contentView.horizontalAnchors == horizontalAnchors
            
            bottomConstraint = contentView.bottomAnchor == bottomAnchor
        }
        else {
            currentContentView?.removeFromSuperview()
            currentContentView = nil
        }
        
        updateLoadingState()
    }
    
    func updateLoadingState() {
        if loading {
            switch state {
            case .none:
                loadingView.isHidden = false
            case .base, .empty, .error:
                loadingView.isHidden = true
            }
        }
        else {
            loadingView.isHidden = true
        }
        
        loadingView.loading = loading
    }
}
