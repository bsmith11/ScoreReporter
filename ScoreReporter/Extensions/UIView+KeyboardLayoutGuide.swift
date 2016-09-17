//
//  UIView+KeyboardLayoutGuide.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/13/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//
//https://github.com/Raizlabs/Swiftilities/blob/develop/Pod/Classes/Keyboard/UIView%2BKeyboardLayoutGuide.swift

import UIKit

public extension UIView {
    var keyboardLayoutGuide: UILayoutGuide {
        if let index = layoutGuides.indexOf({$0 is KeyboardLayoutGuide}) {
            return layoutGuides[index]
        }
        
        return addKeyboardLayoutGuide()
    }
}

private extension UIView {
    func addKeyboardLayoutGuide() -> UILayoutGuide {
        let guide = KeyboardLayoutGuide()
        addLayoutGuide(guide)
        
        guide.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        guide.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        guide.topAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        
        let heightConstraint = guide.heightAnchor.constraintEqualToConstant(0.0)
        heightConstraint.active = true
        
        guide.keyboardFrameBlock = { [weak self] keyboardFrame in
            if let sself = self where sself.window != nil {
                var frameInWindow = sself.frame
                
                if let superview = sself.superview {
                    frameInWindow = superview.convertRect(sself.frame, toView: nil)
                }
                
                heightConstraint.constant = max(0.0, frameInWindow.maxY - keyboardFrame.minY)
                
                sself.layoutIfNeeded()
            }
        }
        
        return guide
    }
}

// MARK: - KeyboardLayoutGuide

private typealias KeyboardFrameBlock = (CGRect) -> Void

private class KeyboardLayoutGuide: UILayoutGuide {
    private var currentKeyboardFrame = CGRect.zero
    
    var keyboardFrameBlock: KeyboardFrameBlock?
    
    override init() {
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillUpdate(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillUpdate(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func keyboardWillUpdate(notification: NSNotification) {
        guard let block = keyboardFrameBlock else {
            return
        }
        
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() ?? CGRect.zero
        
        guard !CGRectEqualToRect(currentKeyboardFrame, keyboardFrame) else {
            return
        }
        
        currentKeyboardFrame = keyboardFrame
        
        let animationDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.0
        let animationCurve = (notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.unsignedIntegerValue ?? 0
        let options = UIViewAnimationOptions(rawValue: animationCurve << 16)
        let animations = {
            block(keyboardFrame)
        }
        
        UIView.animateWithDuration(animationDuration, delay: 0.0, options: options, animations: animations, completion: nil)
    }
}
