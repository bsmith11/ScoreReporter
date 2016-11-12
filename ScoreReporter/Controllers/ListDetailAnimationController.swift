//
//  ListDetailAnimationController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/11/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

protocol ListDetailAnimationControllerDelegate: class {
    var viewToAnimate: UIView { get }
}

class ListDetailAnimationController: NSObject {
    private let duration = 0.35
    
    weak var delegate: ListDetailAnimationControllerDelegate?
}

extension ListDetailAnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
                  toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
                  view = delegate?.viewToAnimate else {
            transitionContext.completeTransition(true)
            return
        }
        
        let container = transitionContext.containerView()
        container.addSubview(toViewController.view)
        container.addSubview(view)
        
        toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)
        toViewController.view.setNeedsLayout()
        toViewController.view.layoutIfNeeded()
        
        var endFrame = view.frame
        endFrame.origin.y = toViewController.view.frame.minY + 16.0
        
        let originalFrame = toViewController.view.frame
        toViewController.view.frame.origin.y = container.frame.maxY
        
        let viewBoundsAnimation = boundsAnimationWithToValueFrame(endFrame)
        let viewPositionAnimation = positionAnimationWithToValueFrame(endFrame)
        
        let fromViewOpacityAnimation = opacityAnimationWithToValue(0.0)
        
        let toViewBoundsAnimation = boundsAnimationWithToValueFrame(originalFrame)
        let toViewPositionAnimation = positionAnimationWithToValueFrame(originalFrame)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            toViewController.view.frame = originalFrame
        
            fromViewController.view.layer.removeAnimationForKey("opacity")
            
            toViewController.view.layer.removeAnimationForKey("bounds")
            toViewController.view.layer.removeAnimationForKey("position")
            
            view.removeFromSuperview()
            
            let completed = !transitionContext.transitionWasCancelled()
            transitionContext.completeTransition(completed)
        }
        
        view.layer.addAnimation(viewBoundsAnimation, forKey: "bounds")
        view.layer.addAnimation(viewPositionAnimation, forKey: "position")
        
        fromViewController.view.layer.addAnimation(fromViewOpacityAnimation, forKey: "opacity")
        
        toViewController.view.layer.addAnimation(toViewBoundsAnimation, forKey: "bounds")
        toViewController.view.layer.addAnimation(toViewPositionAnimation, forKey: "position")
        
        CATransaction.commit()
    }
    
    func springAnimationForKeyPath(keyPath: String, toValue: AnyObject) -> CASpringAnimation {
        let animation = CASpringAnimation(keyPath: keyPath)
        animation.toValue = toValue
        animation.fillMode = kCAFillModeBoth
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.5
        animation.damping = 500.0
        animation.stiffness = 1000.0
        animation.mass = 3.0
        animation.removedOnCompletion = false
        
        return animation
    }
    
    func boundsAnimationWithToValueFrame(toValue: CGRect) -> CASpringAnimation {
        let rect = CGRect(origin: .zero, size: toValue.size)
        let value = NSValue(CGRect: rect)
        
        return springAnimationForKeyPath("bounds", toValue: value)
    }
    
    func positionAnimationWithToValueFrame(toValue: CGRect) -> CASpringAnimation {
        let point = CGPoint(x: toValue.midX, y: toValue.midY)
        let value = NSValue(CGPoint: point)
        
        return springAnimationForKeyPath("position", toValue: value)
    }
    
    func opacityAnimationWithToValue(toValue: CGFloat) -> CASpringAnimation {
        return springAnimationForKeyPath("opacity", toValue: toValue)
    }
}
