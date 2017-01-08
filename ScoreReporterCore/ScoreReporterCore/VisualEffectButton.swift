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
    
    public init(effect: UIVisualEffect) {
        visualEffectView = UIVisualEffectView(effect: effect)
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        super.init(frame: .zero)
        
        layer.cornerRadius = 12.0
        layer.masksToBounds = true
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        layer.borderWidth = (1.0 / UIScreen.main.scale)
        
        setTitleColor(UIColor.black, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightBlack)
        
        addSubview(visualEffectView)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
