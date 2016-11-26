//
//  BackAnimationController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/17/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

class BackAnimationController: NSObject {
    fileprivate let duration = 0.35
    fileprivate let fromContainerView = UIView(frame: .zero)
    fileprivate let toContainerView = UIView(frame: .zero)
    fileprivate let dimmingView = DimmingView(frame: .zero)
    fileprivate let shadowImageView = UIImageView(frame: .zero)
}

// MARK: - UIViewControllerAnimatedTransitioning

extension BackAnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView

        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
                  let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
                  let navigationBar = fromViewController.navigationController?.navigationBar else {
            transitionContext.completeTransition(true)
            return
        }

        let capInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
        let shadowImage = UIImage(named: "navigation-shadow")?.resizableImage(withCapInsets: capInsets)
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

        let navigationBarAnimatorView = NavigationBarAnimatorView(fromViewController: fromViewController, toViewController: toViewController, navigationBar: navigationBar)
        container.addSubview(navigationBarAnimatorView)
        navigationBarAnimatorView.prepareForAnimation()

        let completion = {
            let finished = !transitionContext.transitionWasCancelled

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

            navigationBarAnimatorView.finishAnimation()

            transitionContext.completeTransition(finished)
        }

        let fromAnimation: CABasicAnimation
        let toAnimation: CABasicAnimation
        let dimmingAnimation: CABasicAnimation
        let shadowAnimation: CABasicAnimation

        if transitionContext.isInteractive {
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

        fromAnimation.toValue = NSValue(cgPoint: fromPositionEnd)
        toAnimation.toValue = NSValue(cgPoint: toPositionEnd)
        dimmingAnimation.toValue = 0.0
        shadowAnimation.toValue = 0.0

        fromAnimation.isRemovedOnCompletion = false
        toAnimation.isRemovedOnCompletion = false
        dimmingAnimation.isRemovedOnCompletion = false
        shadowAnimation.isRemovedOnCompletion = false

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        fromContainerView.layer.add(fromAnimation, forKey: "position")
        toContainerView.layer.add(toAnimation, forKey: "position")
        dimmingView.layer.add(dimmingAnimation, forKey: "opacity")
        shadowImageView.layer.add(shadowAnimation, forKey: "opacity")

        navigationBarAnimatorView.animate(with: duration, interactive: transitionContext.isInteractive)

        CATransaction.commit()
    }
}

// MARK: - DimmingView

private class DimmingView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.black.withAlphaComponent(0.1)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
