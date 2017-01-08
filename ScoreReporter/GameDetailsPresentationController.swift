//
//  GameDetailsPresentationController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 1/8/17.
//  Copyright © 2017 Brad Smith. All rights reserved.
//

import UIKit

class GameDetailsPresentationController: UIPresentationController {
    fileprivate let tintView = UIView(frame: .zero)
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        tintView.addGestureRecognizer(gesture)
        tintView.alpha = 0.0
        tintView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let containerView = containerView else {
            return
        }
        
        containerView.addSubview(tintView)
        
        let animations = { [weak self] (context: UIViewControllerTransitionCoordinatorContext) -> Void in
            self?.tintView.alpha = 1.0
        }
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: animations, completion: nil)
    }
    
    override var presentedView: UIView? {
        return presentedViewController.view
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        guard let containerView = containerView else {
            return
        }
        
        tintView.frame = containerView.bounds
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        let animations = { [weak self] (context: UIViewControllerTransitionCoordinatorContext) -> Void in
            self?.tintView.alpha = 0.0
        }
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: animations, completion: nil)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView,
              let gameDetailsViewController = presentedViewController as? GameDetailsViewController else {
            return .zero
        }
        
        let width = containerView.bounds.width
        let height = gameDetailsViewController.height
        let x = CGFloat(0.0)
        let y = max(0.0, containerView.bounds.height - height)
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

// MARK: - Private

private extension GameDetailsPresentationController {
    @objc func handleTap() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
