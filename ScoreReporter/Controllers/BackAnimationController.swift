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
                  toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
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
        
        let completion = {
            let finished = !transitionContext.transitionWasCancelled()
            
            if finished {
                self.toContainerView.layer.position = toPositionEnd
                
                container.addSubview(toViewController.view)
                container.setNeedsDisplay()
                
                self.fromContainerView.removeFromSuperview()
                self.toContainerView.removeFromSuperview()
                self.dimmingView.removeFromSuperview()
            }
            
            transitionContext.completeTransition(finished)
        }
        
        if transitionContext.isInteractive() {
            let animations = {
                self.fromContainerView.center = fromPositionEnd
                self.toContainerView.center = toPositionEnd
                self.dimmingView.alpha = 0.0
                self.shadowImageView.alpha = 0.0
            }
            
            UIView.animateWithDuration(duration, delay: 0.0, options: .CurveLinear, animations: animations, completion: { _ in
                completion()
            })
        }
        else {
            let fromAnimation = springAnimationWithKeyPath("position", toValue: NSValue(CGPoint: fromPositionEnd))
            let toAnimation = springAnimationWithKeyPath("position", toValue: NSValue(CGPoint: toPositionEnd))
            let dimmingAnimation = springAnimationWithKeyPath("opacity", toValue: 0.0)
            let shadowDimmingAnimation = springAnimationWithKeyPath("opacity", toValue: 0.0)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            
            fromContainerView.layer.addAnimation(fromAnimation, forKey: "position")
            toContainerView.layer.addAnimation(toAnimation, forKey: "position")
            dimmingView.layer.addAnimation(dimmingAnimation, forKey: "opacity")
            shadowImageView.layer.addAnimation(shadowDimmingAnimation, forKey: "opacity")
            
            CATransaction.commit()
        }
    }
}

// MARK: - Private

private extension BackAnimationController {
    func springAnimationWithKeyPath(keyPath: String, toValue: NSValue) -> CASpringAnimation {
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
