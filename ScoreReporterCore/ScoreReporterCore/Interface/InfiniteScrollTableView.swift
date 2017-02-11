//
//  InfiniteScrollTableView.swift
//  ScoreReporterCore
//
//  Created by Brad Smith on 2/9/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import UIKit

public protocol InfiniteScrollDelegate: class {
    func shouldBatchFetch(in tableView: InfiniteScrollTableView) -> Bool
    func performBatchFetch(in tableView: InfiniteScrollTableView)
}

open class InfiniteScrollTableView: UITableView {
    fileprivate let interceptor = ProtocolInterceptor()
    fileprivate let spinnerTableFooterView = InfiniteScrollTableFooterView(frame: .zero)
    fileprivate let animationDuration = 0.3
    
    fileprivate var batchFetching = false
    
    public let emptyView = EmptyView(frame: .zero)

    public var batchFetchThreshold = CGFloat(0.7)
    public var empty = false {
        didSet {
            emptyView.state = empty ? .empty : .none
        }
    }
    
    public weak var infiniteScrollDelegate: InfiniteScrollDelegate?
    
    open override weak var delegate: UITableViewDelegate? {
        get {
            return interceptor.receiver as? UITableViewDelegate
        }
        
        set {
            super.delegate = nil
            interceptor.receiver = newValue
            super.delegate = interceptor
        }
    }
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        backgroundView = emptyView
        
        interceptor.interceptor = self
        super.delegate = interceptor
        
        spinnerTableFooterView.sizeToFit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

public extension InfiniteScrollTableView {
    func setFetching(_ fetching: Bool, animated: Bool) {        
        if animated {
            if fetching {
                batchFetching = true
                spinnerTableFooterView.loading = true
                tableFooterView = spinnerTableFooterView
            }
            else {
                let animations = { [weak self] () -> Void in
                    self?.tableFooterView = nil
                }
                
                let completion = { [weak self] (finished: Bool) -> Void in
                    self?.batchFetching = false
                    self?.spinnerTableFooterView.loading = false
                }
                
                UIView.animate(withDuration: animationDuration, animations: animations, completion: completion)
            }
        }
        else {
            spinnerTableFooterView.loading = fetching
            tableFooterView = fetching ? spinnerTableFooterView : nil
            
            batchFetching = fetching
        }
    }
}

// MARK: - UITableViewDelegate

extension InfiniteScrollTableView: UITableViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let infiniteScrollDelegate = infiniteScrollDelegate, !batchFetching, !empty else {
            return
        }
        
        let position = scrollView.contentOffset.y + scrollView.bounds.height
        let threshold = scrollView.contentSize.height * batchFetchThreshold
        
        if position >= threshold && infiniteScrollDelegate.shouldBatchFetch(in: self) {
            infiniteScrollDelegate.performBatchFetch(in: self)
        }
        
        delegate?.scrollViewDidScroll?(scrollView)
    }
}

extension ProtocolInterceptor: UITableViewDelegate {

}
