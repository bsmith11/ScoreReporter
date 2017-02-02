//
//  ListDetailAnimationController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/11/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

public protocol ListDetailAnimationControllerDelegate: class {
    var viewToAnimate: UIView { get }

    func shouldAnimate(to viewController: UIViewController) -> Bool
}

public class ListDetailAnimationController: NSObject {
    fileprivate let duration = 0.35

    public weak var delegate: ListDetailAnimationControllerDelegate?
}

// MARK: - UIViewControllerAnimatedTransitioning

extension ListDetailAnimationController: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
                  let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
                  let view = delegate?.viewToAnimate else {
            transitionContext.completeTransition(true)
            return
        }

        var topSectionFrame = fromViewController.view.bounds
        topSectionFrame.size.height = view.frame.minY - fromViewController.view.frame.minY

        let topSnapshot = fromViewController.view.snapshot(rect: topSectionFrame)
        topSnapshot?.frame.origin.y += fromViewController.view.frame.minY

        var bottomSectionFrame = fromViewController.view.bounds
        bottomSectionFrame.origin.y = view.frame.maxY - fromViewController.view.frame.minY
        bottomSectionFrame.size.height = fromViewController.view.bounds.height - (view.frame.maxY - fromViewController.view.frame.minY)

        let bottomSnapshot = fromViewController.view.snapshot(rect: bottomSectionFrame)
        bottomSnapshot?.frame.origin.y += fromViewController.view.frame.minY

        let container = transitionContext.containerView
        container.addSubview(toViewController.view)
        container.addSubview(view)

        if let topSnapshot = topSnapshot {
            container.addSubview(topSnapshot)
        }

        if let bottomSnapshot = bottomSnapshot {
            container.addSubview(bottomSnapshot)
        }

        toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
        toViewController.view.setNeedsLayout()
        toViewController.view.layoutIfNeeded()

        var endFrame = view.frame
        endFrame.origin.y = toViewController.view.frame.minY + 16.0

        let originalFrame = toViewController.view.frame
        toViewController.view.frame.origin.y = container.frame.maxY

        var topSnapshotEndFrame = topSnapshot?.frame ?? .zero
        topSnapshotEndFrame.origin.y = -topSnapshotEndFrame.height

        var bottomSnapshotEndFrame = bottomSnapshot?.frame ?? .zero
        bottomSnapshotEndFrame.origin.y = container.frame.height

        let viewBoundsAnimation = boundsAnimation(toFrame: endFrame)
        let viewPositionAnimation = positionAnimation(toFrame: endFrame)

        let topSnapshotPositionAnimation = positionAnimation(toFrame: topSnapshotEndFrame)

        let bottomSnapshotPositionAnimation = positionAnimation(toFrame: bottomSnapshotEndFrame)

        let toViewBoundsAnimation = boundsAnimation(toFrame: originalFrame)
        let toViewPositionAnimation = positionAnimation(toFrame: originalFrame)

        fromViewController.view.alpha = 0.0

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            toViewController.view.frame = originalFrame

            fromViewController.view.alpha = 1.0

            toViewController.view.layer.removeAnimation(forKey: "bounds")
            toViewController.view.layer.removeAnimation(forKey: "position")

            view.removeFromSuperview()
            topSnapshot?.removeFromSuperview()
            bottomSnapshot?.removeFromSuperview()

            let completed = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(completed)
        }

        view.layer.add(viewBoundsAnimation, forKey: "bounds")
        view.layer.add(viewPositionAnimation, forKey: "position")

        topSnapshot?.layer.add(topSnapshotPositionAnimation, forKey: "position")

        bottomSnapshot?.layer.add(bottomSnapshotPositionAnimation, forKey: "position")

        toViewController.view.layer.add(toViewBoundsAnimation, forKey: "bounds")
        toViewController.view.layer.add(toViewPositionAnimation, forKey: "position")

        CATransaction.commit()
    }
}

// MARK: - Helpers

extension ListDetailAnimationController {
    func springAnimation(keyPath: String, toValue: AnyObject) -> CASpringAnimation {
        let animation = CASpringAnimation(keyPath: keyPath)
        animation.toValue = toValue
        animation.fillMode = kCAFillModeBoth
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.5
        animation.damping = 500.0
        animation.stiffness = 1000.0
        animation.mass = 3.0
        animation.isRemovedOnCompletion = false

        return animation
    }

    func boundsAnimation(toFrame toValue: CGRect) -> CASpringAnimation {
        let rect = CGRect(origin: .zero, size: toValue.size)
        let value = NSValue(cgRect: rect)

        return springAnimation(keyPath: "bounds", toValue: value)
    }

    func positionAnimation(toFrame toValue: CGRect) -> CASpringAnimation {
        let point = CGPoint(x: toValue.midX, y: toValue.midY)
        let value = NSValue(cgPoint: point)

        return springAnimation(keyPath: "position", toValue: value)
    }

    func opacityAnimation(toAlpha toValue: CGFloat) -> CASpringAnimation {
        return springAnimation(keyPath: "opacity", toValue: toValue as AnyObject)
    }
}
