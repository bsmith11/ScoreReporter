//
//  BackInteractionController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import UIKit

protocol BackInteractionControllerDelegate: class {
    func interactionDidBegin()
}

class BackInteractionController: NSObject {
    fileprivate var displayLink: CADisplayLink?
    fileprivate var transitionContext: UIViewControllerContextTransitioning?

    let panGestureRecognizer = UIPanGestureRecognizer()

    fileprivate(set) var interactive = false

    var duration: TimeInterval {
        return animationController?.transitionDuration(using: transitionContext) ?? 0.35
    }

    var timeOffset: TimeInterval {
        get {
            return transitionContext?.containerView.layer.timeOffset ?? 0.0
        }

        set {
            transitionContext?.containerView.layer.timeOffset = newValue
        }
    }

    weak var delegate: BackInteractionControllerDelegate?
    weak var animationController: UIViewControllerAnimatedTransitioning?

    override init() {
        super.init()

        panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
    }

    func update(percentComplete: CGFloat) {
        let boundedPercentComplete = min(max(percentComplete, 0.0), 1.0)
        timeOffset = Double(boundedPercentComplete) * duration

        transitionContext?.updateInteractiveTransition(boundedPercentComplete)
    }

    func cancel() {
        guard let transitionContext = transitionContext else {
            return
        }

        transitionContext.cancelInteractiveTransition()
        completeTransition()
    }

    func finish() {
        guard let transitionContext = transitionContext else {
            return
        }

        transitionContext.finishInteractiveTransition()
        completeTransition()
    }
}

// MARK: - Private

private extension BackInteractionController {
    @objc func handlePan(_ panRecognizer: UIPanGestureRecognizer) {
        switch panRecognizer.state {
        case .began:
            guard panRecognizer.velocity(in: panRecognizer.view).x > 0.0 else {
                return
            }

            interactive = true
            delegate?.interactionDidBegin()
        case .changed:
            guard let view = panRecognizer.view else {
                cancel()
                return
            }

            let translation = panRecognizer.translation(in: view)
            if translation.x > 0.0 {
                let percent = translation.x / view.bounds.width
                update(percentComplete: percent)
            }
            else {
                update(percentComplete: 0.0)
            }
        case .ended:
            guard let view = panRecognizer.view else {
                cancel()
                return
            }

            if panRecognizer.velocity(in: view).x > 200.0 || panRecognizer.translation(in: view).x > view.bounds.midX {
                finish()
            }
            else {
                cancel()
            }

            interactive = false
        default:
            break
        }
    }

    func completeTransition() {
        displayLink = CADisplayLink(target: self, selector: #selector(tickAnimation))
        displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }

    func transitionFinished() {
        guard let transitionContext = transitionContext else {
            return
        }

        displayLink?.invalidate()

        let layer = transitionContext.containerView.layer
        layer.speed = 1.0
        layer.timeOffset = 0.0

        if !transitionContext.transitionWasCancelled {
//            let pausedTime = layer.timeOffset
//            layer.timeOffset = 0.0
//            layer.beginTime = 0.0
//
//            let timeSincePause = layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
//            layer.beginTime = timeSincePause
        }
    }

    @objc func tickAnimation() {
        guard let transitionContext = transitionContext else {
            return
        }

        let displayLinkDuration = displayLink?.duration ?? 0.0
        let tick = displayLinkDuration * TimeInterval(completionSpeed)

        var offset = timeOffset
        offset += transitionContext.transitionWasCancelled ? -tick : tick
        timeOffset = min(max(offset, 0.0), duration)

        if offset <= 0.0 || offset >= duration {
            transitionFinished()
        }
    }
}

// MARK: - UIViewControllerInteractiveTransitioning

extension BackInteractionController: UIViewControllerInteractiveTransitioning {
    var completionSpeed: CGFloat {
        return 1.0
    }

    var completionCurve: UIViewAnimationCurve {
        return .linear
    }

    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let animationController = animationController else {
            return
        }

        self.transitionContext = transitionContext

        transitionContext.containerView.layer.speed = 0.0
        animationController.animateTransition(using: transitionContext)
    }
}
