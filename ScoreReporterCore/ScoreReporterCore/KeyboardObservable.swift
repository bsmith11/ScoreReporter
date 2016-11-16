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

public typealias KeyboardAnimationBlock = (Bool, CGRect) -> Void

public protocol KeyboardObservable: class {
    
}

// MARK: - Public

public extension KeyboardObservable {
    func addKeyboardObserver(with keyboardAnimationBlock: KeyboardAnimationBlock?) {
        let object = keyboardObserverObject()
        object.keyboardAnimationBlock = keyboardAnimationBlock
        
        NotificationCenter.default.addObserver(object, selector: #selector(KeyboardObserverObject.keyboardWillUpdate(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(object, selector: #selector(KeyboardObserverObject.keyboardWillUpdate(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardObserver() {
        let object = keyboardObserverObject()
        
        NotificationCenter.default.removeObserver(object, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(object, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
    
    @objc func keyboardWillUpdate(_ notification: Notification) {
        if let keyboardAnimationBlock = keyboardAnimationBlock {
            let animationCurve = (notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? 0
            let animationDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.0
            let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
            let keyboardVisible = notification.name == NSNotification.Name.UIKeyboardWillShow
            let options = UIViewAnimationOptions(rawValue: animationCurve << 16)
            let animations = {
                keyboardAnimationBlock(keyboardVisible, keyboardFrame)
            }
            
            UIView.animate(withDuration: animationDuration, delay: 0.0, options: options, animations: animations, completion: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
