//
//  BaseNavigationController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import ScoreReporterCore

class BaseNavigationController: UINavigationController {
    fileprivate let interactionController = BackInteractionController()

    fileprivate var animationController: BackAnimationController?

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)

        interactionController.delegate = self
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        delegate = self
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var childViewControllerForStatusBarStyle: UIViewController? {
        return topViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        view.addGestureRecognizer(interactionController.panGestureRecognizer)
    }
}

// MARK: - Public

extension BaseNavigationController {
    var interactionControllerEnabled: Bool {
        get {
            return interactionController.panGestureRecognizer.isEnabled
        }
        
        set {
            interactionController.panGestureRecognizer.isEnabled = newValue
        }
    }
}

// MARK: - BackInteractionControllerDelegate

extension BaseNavigationController: BackInteractionControllerDelegate {
    func interactionDidBegin() {
        popViewController(animated: true)
    }
}

// MARK: - UINavigationControllerDelegate

extension BaseNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationController = BackAnimationController()
        return operation == .pop ? animationController : nil
    }

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactionController.animationController = animationController

        return interactionController.interactive ? interactionController : nil
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        interactionController.panGestureRecognizer.isEnabled = navigationController.viewControllers.first != viewController
    }
}

extension UIViewController {
    var baseNavigationController: BaseNavigationController? {
        return navigationController as? BaseNavigationController
    }
}
