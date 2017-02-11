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
    case empty
    case error
}

public class EmptyView: UIView {
    fileprivate var contentViews = [EmptyViewState: UIView]()
    
    fileprivate weak var currentContentView: UIView?
    
    public var state: EmptyViewState = .none {
        didSet {
            update(withState: state)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        update(withState: state)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

public extension EmptyView {
    func set(contentView: UIView?, forState state: EmptyViewState) {
        contentViews[state] = contentView
        update(withState: state)
    }
}

// MARK: - Private

private extension EmptyView {
    func update(withState state: EmptyViewState) {
        if let contentView = contentViews[state] {
            if contentView != currentContentView {
                currentContentView?.removeFromSuperview()
                currentContentView = contentView
                
                addSubview(contentView)
                contentView.edgeAnchors == edgeAnchors
            }
        }
        else {
            currentContentView?.removeFromSuperview()
            currentContentView = nil
        }
    }
}
