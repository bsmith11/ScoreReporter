//
//  BaseNavigationController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    private let interactionController = BackInteractionController()
    
    private var animationController: BackAnimationController?
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        interactionController.delegate = self
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
        
        view.backgroundColor = UIColor.whiteColor()
        view.addGestureRecognizer(interactionController.panGestureRecognizer)
    }
}

// MARK: - BackInteractionControllerDelegate

extension BaseNavigationController: BackInteractionControllerDelegate {
    func interactionDidBegin() {
        popViewControllerAnimated(true)
    }
}

// MARK: - UINavigationControllerDelegate

extension BaseNavigationController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let listDelegate = fromVC as? ListDetailAnimationControllerDelegate where operation == .Push {
            let animationController = ListDetailAnimationController()
            animationController.delegate = listDelegate
            
            return animationController
        }
        else {
            animationController = BackAnimationController()
            
            return operation == .Pop ? animationController : ListDetailAnimationController()
        }
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactionController.animationController = animationController
        
        return interactionController.interactive ? interactionController : nil
    }
}
