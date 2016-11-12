//
//  BackAnimationController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/17/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

class BackAnimationController: NSObject {
    private let duration = 0.35
    private let fromContainerView = UIView(frame: .zero)
    private let toContainerView = UIView(frame: .zero)
    private let dimmingView = DimmingView(frame: .zero)
    private let shadowImageView = UIImageView(frame: .zero)
}

// MARK: - UIViewControllerAnimatedTransitioning

extension BackAnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()
        
        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
                  toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
                  navigationBar = fromViewController.navigationController?.navigationBar else {
            transitionContext.completeTransition(true)
            return
        }
                
        let capInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
        let shadowImage = UIImage(named: "navigation-shadow")?.resizableImageWithCapInsets(capInsets)
        shadowImageView.image = shadowImage
        shadowImageView.frame = toViewController.view.frame
        shadowImageView.frame.origin.x = -9.0
        shadowImageView.frame.size.width = 9.0
        
        fromContainerView.clipsToBounds = false
        fromContainerView.frame = container.bounds
        fromContainerView.addSubview(shadowImageView)
        fromContainerView.addSubview(fromViewController.view)
        
        dimmingView.frame = container.bounds
        
        toContainerView.addSubview(toViewController.view)
        
        container.addSubview(toContainerView)
        container.addSubview(dimmingView)
        container.addSubview(fromContainerView)
        
        let fromPositionBegin = fromContainerView.layer.position
        
        var fromPositionEnd = fromContainerView.layer.position
        fromPositionEnd.x += fromContainerView.layer.bounds.width
        
        var toPositionBegin = toContainerView.layer.position
        toPositionBegin.x -= 112.0
        
        let toPositionEnd = toContainerView.layer.position
        
        fromContainerView.layer.position = fromPositionBegin
        toContainerView.layer.position = toPositionBegin
        
//        let navigationBarAnimatorView = NavigationBarAnimatorView(fromViewController: fromViewController, toViewController: toViewController, navigationBar: navigationBar)
//        container.addSubview(navigationBarAnimatorView)
//        navigationBarAnimatorView.prepareForAnimation()
        
        let completion = {
            let finished = !transitionContext.transitionWasCancelled()
            
            if finished {
                container.addSubview(fromViewController.view)
                container.addSubview(toViewController.view)
            }
            else {
                container.addSubview(fromViewController.view)
            }
            
            self.fromContainerView.removeFromSuperview()
            self.toContainerView.removeFromSuperview()
            self.dimmingView.removeFromSuperview()
            
//            navigationBarAnimatorView.finishAnimation()
            
            transitionContext.completeTransition(finished)
        }
        
        let fromAnimation: CABasicAnimation
        let toAnimation: CABasicAnimation
        let dimmingAnimation: CABasicAnimation
        let shadowAnimation: CABasicAnimation
        
        if transitionContext.isInteractive() {
            let timingFunctionName = kCAMediaTimingFunctionLinear
            
            fromAnimation = CABasicAnimation(keyPath: "position", timingFunctionName: timingFunctionName, duration: duration)
            toAnimation = CABasicAnimation(keyPath: "position", timingFunctionName: timingFunctionName, duration: duration)
            dimmingAnimation = CABasicAnimation(keyPath: "opacity", timingFunctionName: timingFunctionName, duration: duration)
            shadowAnimation = CABasicAnimation(keyPath: "opacity", timingFunctionName: timingFunctionName, duration: duration)
        }
        else {
            let springDuration = 0.5
            
            fromAnimation = CASpringAnimation(keyPath: "position", duration: springDuration)
            toAnimation = CASpringAnimation(keyPath: "position", duration: springDuration)
            dimmingAnimation = CASpringAnimation(keyPath: "opacity", duration: springDuration)
            shadowAnimation = CASpringAnimation(keyPath: "opacity", duration: springDuration)
        }
        
        fromAnimation.toValue = NSValue(CGPoint: fromPositionEnd)
        toAnimation.toValue = NSValue(CGPoint: toPositionEnd)
        dimmingAnimation.toValue = 0.0
        shadowAnimation.toValue = 0.0
        
        fromAnimation.removedOnCompletion = false
        toAnimation.removedOnCompletion = false
        dimmingAnimation.removedOnCompletion = false
        shadowAnimation.removedOnCompletion = false
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        
        fromContainerView.layer.addAnimation(fromAnimation, forKey: "position")
        toContainerView.layer.addAnimation(toAnimation, forKey: "position")
        dimmingView.layer.addAnimation(dimmingAnimation, forKey: "opacity")
        shadowImageView.layer.addAnimation(shadowAnimation, forKey: "opacity")
        
//        navigationBarAnimatorView.animateWithDuration(duration, interactive: transitionContext.isInteractive())
        
        CATransaction.commit()
    }
}

// MARK: - DimmingView

private class DimmingView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
