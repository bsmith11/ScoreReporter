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
        if let index = layoutGuides.index(where: { $0 is KeyboardLayoutGuide }) {
            return layoutGuides[index]
        }
        
        return addKeyboardLayoutGuide()
    }
}

private extension UIView {
    func addKeyboardLayoutGuide() -> UILayoutGuide {
        let guide = KeyboardLayoutGuide()
        addLayoutGuide(guide)
        
        guide.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        guide.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        guide.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let heightConstraint = guide.heightAnchor.constraint(equalToConstant: 0.0)
        heightConstraint.isActive = true
        
        guide.keyboardFrameBlock = { [weak self] keyboardFrame in
            if let sself = self, sself.window != nil {
                var frameInWindow = sself.frame
                
                if let superview = sself.superview {
                    frameInWindow = superview.convert(sself.frame, to: nil)
                }
                
                heightConstraint.constant = max(0.0, frameInWindow.maxY - keyboardFrame.minY)
                
                sself.superview?.layoutIfNeeded()
            }
        }
        
        return guide
    }
}

// MARK: - KeyboardLayoutGuide

private typealias KeyboardFrameBlock = (CGRect) -> Void

private class KeyboardLayoutGuide: UILayoutGuide {
    fileprivate var currentKeyboardFrame = CGRect.zero
    
    var keyboardFrameBlock: KeyboardFrameBlock?
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillUpdate(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillUpdate(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func keyboardWillUpdate(_ notification: Notification) {
        guard let block = keyboardFrameBlock else {
            return
        }
        
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
        
        guard !currentKeyboardFrame.equalTo(keyboardFrame) else {
            return
        }
        
        currentKeyboardFrame = keyboardFrame
        
        let animationDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.0
        let animationCurve = (notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? 0
        let options = UIViewAnimationOptions(rawValue: animationCurve << 16)
        let animations = {
            block(keyboardFrame)
        }
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: options, animations: animations, completion: nil)
    }
}
