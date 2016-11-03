//
//  BaseNavigationController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var interactionController: UIPercentDrivenInteractiveTransition?
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return topViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panRecognizer)
    }
}

// MARK: - Private

private extension BaseNavigationController {
    @objc func handlePan(panRecognizer: UIPanGestureRecognizer) {
        switch panRecognizer.state {
        case .Began:
            interactionController = UIPercentDrivenInteractiveTransition()
            popViewControllerAnimated(true)
        case .Changed:
            let translation = panRecognizer.translationInView(view)
            if translation.x > 0.0 {
                let percent = translation.x / view.bounds.width
                interactionController?.updateInteractiveTransition(percent)
            }
            else {
                interactionController?.updateInteractiveTransition(0.0)
            }
        case .Ended:
            if panRecognizer.velocityInView(view).x > 200.0 || panRecognizer.translationInView(view).x > view.bounds.midX {
                interactionController?.finishInteractiveTransition()
            }
            else {
                interactionController?.cancelInteractiveTransition()
            }
            
            interactionController = nil
        default:
            break
        }
    }
}

// MARK: - UINavigationControllerDelegate

extension BaseNavigationController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return operation == .Pop ? BackAnimationController() : nil
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}
