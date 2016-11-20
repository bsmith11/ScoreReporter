//
//  SegmentedControl.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/13/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

public protocol SegmentedControlDelegate: class {
    func didSelect(index: Int, segmentedControl: SegmentedControl)
}

public class SegmentedControl: UIView {
    fileprivate var segmentStackView = UIStackView(frame: .zero)
    fileprivate var segments: [SegmentView] {
        return segmentStackView.arrangedSubviews as? [SegmentView] ?? []
    }
    
    public var font: UIFont? = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightBlack) {
        didSet {
            segments.forEach { $0.font = font }
        }
    }
    
    public var selectedIndex: Int? {
        didSet {
            if oldValue != selectedIndex {
                segments.forEach { $0.selected = false }
                
                if let index = selectedIndex, index < segmentStackView.arrangedSubviews.count {
                    segments[index].selected = true
                    delegate?.didSelect(index: index, segmentedControl: self)
                }
            }
        }
    }
    
    public var numberOfSegments: Int {
        return segmentStackView.arrangedSubviews.count
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: 44.0)
    }
    
    public weak var delegate: SegmentedControlDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        configureLayout()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        
        segments.forEach { $0.tintColor = tintColor }
    }
}

// MARK: - Public

public extension SegmentedControl {
    func setSegments(with titles: [String?]) {
        segmentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        titles.forEach { title in
            let segment = SegmentView(frame: .zero)
            segment.title = title
            segment.font = font
            segment.tintColor = tintColor
            segment.delegate = self
            segmentStackView.addArrangedSubview(segment)
        }
    }
}

// MARK: - Private

private extension SegmentedControl {
    func configureViews() {
        segmentStackView.axis = .horizontal
        segmentStackView.distribution = .fillEqually
        addSubview(segmentStackView)
    }
    
    func configureLayout() {
        segmentStackView.edgeAnchors == edgeAnchors
    }
}

// MARK: - SegmentViewDelegate

extension SegmentedControl: SegmentViewDelegate {
    func didSelect(segmentView: SegmentView) {
        selectedIndex = segmentStackView.arrangedSubviews.index(of: segmentView)
    }
}
