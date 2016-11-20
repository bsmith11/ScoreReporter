//
//  SegmentView.swift
//  ScoreReporterCore
//
//  Created by Bradley Smith on 11/20/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import UIKit
import Anchorage

protocol SegmentViewDelegate: class {
    func didSelect(segmentView: SegmentView)
}

class SegmentView: UIView {
    fileprivate let button = UIButton(type: .custom)
    fileprivate let selectionView = UIView(frame: .zero)
    
    fileprivate var selectionViewHeight: NSLayoutConstraint?
    
    var selected = false {
        didSet {
            selectionViewHeight?.constant = selected ? 4.0 : 1.0
            button.isSelected = selected
        }
    }
    
    var font: UIFont? {
        get {
            return button.titleLabel?.font
        }
        
        set {
            button.titleLabel?.font = newValue
        }
    }
    
    var title: String? {
        get {
            return button.title(for: .normal)
        }
        
        set {
            button.setTitle(newValue, for: .normal)
        }
    }
    
    weak var delegate: SegmentViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        selectionView.backgroundColor = tintColor
        button.setTitleColor(tintColor, for: .selected)
    }
}

// MARK: - Private

private extension SegmentView {
    func configureViews() {
        button.setTitleColor(UIColor.gray, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        addSubview(button)
        
        selectionView.backgroundColor = tintColor
        addSubview(selectionView)
    }
    
    func configureLayout() {
        button.edgeAnchors == edgeAnchors
        
        selectionView.horizontalAnchors == horizontalAnchors
        selectionView.bottomAnchor == bottomAnchor
        selectionViewHeight = selectionView.heightAnchor == 1.0
    }
    
    @objc func buttonPressed() {
        delegate?.didSelect(segmentView: self)
    }
}
