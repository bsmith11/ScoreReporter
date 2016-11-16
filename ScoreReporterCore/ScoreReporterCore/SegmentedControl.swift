//
//  SegmentedControl.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/13/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

public protocol SegmentedControlDelegate: class {
    func segmentedControlDidSelect(index: Int)
}

public class SegmentedControl: UISegmentedControl {
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightBlack) {
        didSet {
            setTitleFont(titleFont, titleColor: titleColor(for: .normal), for: .normal)
        }
    }
    
    public override var selectedSegmentIndex: Int {
        didSet {
            delegate?.segmentedControlDidSelect(index: selectedSegmentIndex)
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: 44.0)
    }
    
    public weak var delegate: SegmentedControlDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(UIColor.gray, for: .normal)
        setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

public extension SegmentedControl {
    func setTitleColor(_ titleColor: UIColor?, for state: UIControlState) {
        setTitleFont(titleFont, titleColor: titleColor, for: state)
    }
    
    func titleColor(for state: UIControlState) -> UIColor? {
        return titleTextAttributes(for: state)?[NSForegroundColorAttributeName] as? UIColor
    }
}

// MARK: - Private

private extension SegmentedControl {
    func setTitleFont(_ titleFont: UIFont, titleColor: UIColor?, for state: UIControlState) {
        let attributes: [String: AnyObject] = [
            NSFontAttributeName: titleFont,
            NSForegroundColorAttributeName: titleColor ?? UIColor.gray
        ]
        
        setTitleTextAttributes(attributes, for: state)
    }
    
    @objc func segmentedControlValueChanged() {
        delegate?.segmentedControlDidSelect(index: selectedSegmentIndex)
    }
}
