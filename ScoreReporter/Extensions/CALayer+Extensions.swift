//
//  CALayer+Extensions.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/2/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    public override class func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        // make sure this isn't a subclass
        if self !== CALayer.self {
            return
        }
        
        dispatch_once(&Static.token) {
            let originalSelector = Selector("addAnimation:forKey:")
            let swizzledSelector = Selector("xxx_addAnimation:forKey:")
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }
    
    func xxx_addAnimation(animation: CAAnimation, forKey key: String) {
        xxx_addAnimation(animation, forKey: key)
        
        guard let delegate = delegate else {
            return
        }
        
        let className = NSStringFromClass(delegate.dynamicType)
                
        print("Class: \(className) \(unsafeAddressOf(delegate))")
        
        if let object = delegate as? NSObject where object.respondsToSelector(Selector("title")) {
            if let title = object.valueForKeyPath("title") {
                print("Title: \(title)")
            }
        }
        
        print("\(animationDescriptions)")
        print("----------------------------------------------------------------------------\n\n")
    }
    
    var animations: [CAAnimation] {
        return (animationKeys() ?? []).flatMap { key -> CAAnimation? in
            return animationForKey(key)
        }
    }
    
    var animationDescriptions: String {
        var description = ""
        
        animations.forEach { animation in
            description.appendContentsOf("\n")
            description.appendContentsOf(NSStringFromClass(animation.dynamicType))
            description.appendContentsOf("\n")
            
            if let basicAnimation = animation as? CABasicAnimation {
                if let keyPath = basicAnimation.keyPath {
                    description.appendContentsOf("keyPath: \(keyPath)\n")
                }
                
                if let fromValue = basicAnimation.fromValue {
                    description.appendContentsOf("fromValue: \(fromValue)\n")
                }
                
                if let toValue = basicAnimation.toValue {
                    description.appendContentsOf("toValue: \(toValue)\n")
                }
                else if let keyPath = basicAnimation.keyPath {
                    if let toValue = valueForKeyPath(keyPath) {
                        description.appendContentsOf("toValue: \(toValue)\n")
                    }
                    else {
                        description.appendContentsOf("toValue: nil\n")
                    }
                }
            }
            
            description.appendContentsOf("fillMode: \(animation.fillMode)\n")
            
            if let timingFunction = animation.timingFunction {
                description.appendContentsOf("timingFunction: \(timingFunction)\n")
            }
            
            description.appendContentsOf("duration: \(animation.duration)\n")
            description.appendContentsOf("\n")
        }
        
        return description
    }
}

extension UIView {
    var hierarchyContainsNavigationBar: Bool {
        var superviewObject = superview
        
        while superviewObject != nil {
            if superviewObject is UINavigationBar {
                return true
            }
            
            superviewObject = superviewObject?.superview
        }
        
        return false
    }
}
