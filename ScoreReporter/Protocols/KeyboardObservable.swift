//
//  KeyboardObservable.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

typealias KeyboardAnimationBlock = (Bool, CGRect) -> Void

protocol KeyboardObservable: class {
    
}

// MARK: - Public

extension KeyboardObservable {
    func addKeyboardObserverWithAnimationBlock(keyboardAnimationBlock: KeyboardAnimationBlock?) {
        let object = keyboardObserverObject()
        object.keyboardAnimationBlock = keyboardAnimationBlock
        
        NSNotificationCenter.defaultCenter().addObserver(object, selector: #selector(KeyboardObserverObject.keyboardWillUpdate(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(object, selector: #selector(KeyboardObserverObject.keyboardWillUpdate(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        let object = keyboardObserverObject()
        
        NSNotificationCenter.defaultCenter().removeObserver(object, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(object, name: UIKeyboardWillHideNotification, object: nil)
        
        removeKeyboardObserverObject()
    }
}

// MARK: - Private

private extension KeyboardObservable {
    func keyboardObserverObject() -> KeyboardObserverObject {
        if let object = objc_getAssociatedObject(self, &KeyboardObserverObject.keyboardObserverAssociatedKey) as? KeyboardObserverObject {
            return object
        }
        else {
            let object = KeyboardObserverObject()
            objc_setAssociatedObject(self, &KeyboardObserverObject.keyboardObserverAssociatedKey, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            return object
        }
    }
    
    func removeKeyboardObserverObject() {
        objc_setAssociatedObject(self, &KeyboardObserverObject.keyboardObserverAssociatedKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

// MARK: - KeyboardObserverObject

class KeyboardObserverObject {
    static var keyboardObserverAssociatedKey = "com.bradsmith.scorereporter.keyboardObserverAssociatedKey"
    
    var keyboardAnimationBlock: KeyboardAnimationBlock?
    
    @objc func keyboardWillUpdate(notification: NSNotification) {
        if let keyboardAnimationBlock = keyboardAnimationBlock {
            let animationCurve = (notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.unsignedIntegerValue ?? 0
            let animationDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.0
            let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() ?? CGRect.zero
            let keyboardVisible = notification.name == UIKeyboardWillShowNotification
            let options = UIViewAnimationOptions(rawValue: animationCurve << 16)
            let animations = {
                keyboardAnimationBlock(keyboardVisible, keyboardFrame)
            }
            
            UIView.animateWithDuration(animationDuration, delay: 0.0, options: options, animations: animations, completion: nil)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
