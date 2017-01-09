//
//  VisualEffectButton.swift
//  ScoreReporterCore
//
//  Created by Bradley Smith on 1/8/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import UIKit

public class VisualEffectButton: UIButton {
    fileprivate let visualEffectView: UIVisualEffectView
    fileprivate let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    fileprivate var internalTitle: String?
    
    public var loading: Bool = false {
        didSet {
            guard oldValue != loading else {
                return
            }
            
            isEnabled = !loading
            
            if loading {
                internalTitle = title(for: .normal)
                setTitle(nil, for: .normal)
                
                spinner.startAnimating()
            }
            else {
                spinner.stopAnimating()
                
                setTitle(internalTitle, for: .normal)
                internalTitle = nil
            }
        }
    }
    
    public override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.black.withAlphaComponent(0.5) : UIColor.clear
        }
    }
    
    public init(effect: UIVisualEffect) {
        visualEffectView = UIVisualEffectView(effect: effect)
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.isUserInteractionEnabled = false
        
        super.init(frame: .zero)
        
        layer.cornerRadius = 12.0
        layer.masksToBounds = true
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        layer.borderWidth = (1.0 / UIScreen.main.scale)
        
        setTitleColor(UIColor.black, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightBlack)
        
        insertSubview(visualEffectView, at: 0)
        
        spinner.hidesWhenStopped = true
        spinner.color = UIColor.black
        insertSubview(spinner, aboveSubview: visualEffectView)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let x = bounds.width / 2.0
        let y = bounds.height / 2.0
        
        spinner.center = CGPoint(x: x, y: y)
    }
}
