//
//  NavigationBarAnimatorView.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 10/30/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit

class NavigationBarAnimatorView: UIView {
    private let fromViewController: UIViewController
    private let toViewController: UIViewController
    private let navigationBar: UINavigationBar
    private let backButtonImageView = UIImageView(frame: .zero)
    
    private let backIconWidth = CGFloat(13.0)
    private let backIconSpacing = CGFloat(6.0)
    private let leadingMargin = CGFloat(8.0)
    
    private var incomingNavigationItemButtonView: NavigationItemButtonView?
    private var leftNavigationItemButtonView: NavigationItemButtonView?
    private var leftNavigationItemView: NavigationItemView?
    private var centerNavigationItemView: NavigationItemView?
    
    init(fromViewController: UIViewController, toViewController: UIViewController, navigationBar: UINavigationBar) {
        self.fromViewController = fromViewController
        self.toViewController = toViewController
        self.navigationBar = navigationBar
        
        super.init(frame: navigationBar.frame)
        
        backgroundColor = navigationBar.barTintColor
        clipsToBounds = false
        
        let backgroundViewFrame = CGRect(x: 0.0, y: -20.0, width: frame.width, height: frame.height + 20.0)
        let backgroundView = UIView(frame: backgroundViewFrame)
        backgroundView.backgroundColor = backgroundColor
        addSubview(backgroundView)
        
        backButtonImageView.contentMode = .Center
        backButtonImageView.image = UIImage(named: "icn-navigation-back")?.imageWithRenderingMode(.AlwaysTemplate)
        backButtonImageView.tintColor = navigationBar.tintColor
        backButtonImageView.sizeToFit()
        backButtonImageView.center = boundsCenter
        backButtonImageView.frame.origin.x = leadingMargin
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension NavigationBarAnimatorView {
    func prepareForAnimation() {
        navigationBar.hidden = true
        
        incomingNavigationItemButtonView = incomingBackViewController.flatMap { NavigationItemButtonView(viewController: $0, backImageWidth: backIconWidth) }
        
        if let incomingNavigationItemButtonView = incomingNavigationItemButtonView {
            incomingNavigationItemButtonView.alpha = 0.3
            incomingNavigationItemButtonView.center = boundsCenter
            incomingNavigationItemButtonView.frame.origin.x = -incomingNavigationItemButtonView.bounds.width
            addSubview(incomingNavigationItemButtonView)
        }
        
        leftNavigationItemButtonView = NavigationItemButtonView(viewController: toViewController, backImageWidth: backIconWidth)
        
        if let leftNavigationItemButtonView = leftNavigationItemButtonView {
            leftNavigationItemButtonView.center = boundsCenter
            leftNavigationItemButtonView.frame.origin.x = leadingMargin
            addSubview(leftNavigationItemButtonView)
        }
        
        leftNavigationItemView = NavigationItemView(viewController: toViewController)
        
        if let leftNavigationItemView = leftNavigationItemView {
            leftNavigationItemView.alpha = 0.0
            leftNavigationItemView.center = boundsCenter
            leftNavigationItemView.frame.origin.x = leadingMargin + backIconWidth + backIconSpacing
            addSubview(leftNavigationItemView)
        }
        
        centerNavigationItemView = NavigationItemView(viewController: fromViewController)
        
        if let centerNavigationItemView = centerNavigationItemView {
            centerNavigationItemView.center = boundsCenter
            addSubview(centerNavigationItemView)
        }

        addSubview(backButtonImageView)
    }
    
    func interactiveAnimate() {
        if let incomingNavigationItemButtonView = incomingNavigationItemButtonView {
            let x = leadingMargin + (incomingNavigationItemButtonView.layer.bounds.width / 2.0)
            let y = incomingNavigationItemButtonView.layer.position.y
            
            incomingNavigationItemButtonView.center = CGPoint(x: x, y: y)
            incomingNavigationItemButtonView.alpha = 1.0
        }
        
        if let leftNavigationItemButtonView = leftNavigationItemButtonView {
            var position = leftNavigationItemButtonView.centerPosition
            position.x -= (backIconWidth / 2.0) + (backIconSpacing / 2.0)
            
            leftNavigationItemButtonView.center = position
            leftNavigationItemButtonView.alpha = 0.0
        }
        
        if let leftNavigationItemView = leftNavigationItemView {
            let position = leftNavigationItemView.centerPosition
            
            leftNavigationItemView.center = position
            leftNavigationItemView.alpha = 1.0
        }
        
        if let centerNavigationItemView = centerNavigationItemView {
            let x = navigationBar.frame.maxX + (centerNavigationItemView.layer.bounds.width / 2.0)
            let y = centerNavigationItemView.layer.position.y
            
            centerNavigationItemView.center = CGPoint(x: x, y: y)
            centerNavigationItemView.alpha = 0.0
        }
        
        if toViewController.navigationController?.viewControllers.first == toViewController {
            backButtonImageView.alpha = 0.0
        }
    }
    
    func animate() {
        if let incomingNavigationItemButtonView = incomingNavigationItemButtonView {
            let x = leadingMargin + (incomingNavigationItemButtonView.layer.bounds.width / 2.0)
            let y = incomingNavigationItemButtonView.layer.position.y
            let positionAnimation = springAnimationWithKeyPath("position", toValue: NSValue(CGPoint: CGPoint(x: x, y: y)))
            let opacityAnimation = animationWithKeyPath("opacity", toValue: 1.0)
            opacityAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.75, 0.1, 0.75, 0.1)
            
            incomingNavigationItemButtonView.layer.addAnimation(positionAnimation, forKey: "position")
            incomingNavigationItemButtonView.layer.addAnimation(opacityAnimation, forKey: "opacity")
        }
        
        if let leftNavigationItemButtonView = leftNavigationItemButtonView {
            let position = leftNavigationItemButtonView.centerPosition
            let positionAnimation = springAnimationWithKeyPath("position", toValue: NSValue(CGPoint: position))
            let opacityAnimation = animationWithKeyPath("opacity", toValue: 0.0)
            opacityAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0.9, 0.25, 0.9)
            
            leftNavigationItemButtonView.layer.addAnimation(positionAnimation, forKey: "position")
            leftNavigationItemButtonView.layer.addAnimation(opacityAnimation, forKey: "opacity")
        }
        
        if let leftNavigationItemView = leftNavigationItemView {
            let position = leftNavigationItemView.centerPosition
            let positionAnimation = springAnimationWithKeyPath("position", toValue: NSValue(CGPoint: position))
            let opacityAnimation = animationWithKeyPath("opacity", toValue: 1.0)
            opacityAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.75, 0.1, 0.75, 0.1)
            
            leftNavigationItemView.layer.addAnimation(positionAnimation, forKey: "position")
            leftNavigationItemView.layer.addAnimation(opacityAnimation, forKey: "opacity")
        }
        
        if let centerNavigationItemView = centerNavigationItemView {
            let x = navigationBar.frame.maxX + (centerNavigationItemView.layer.bounds.width / 2.0)
            let y = centerNavigationItemView.layer.position.y
            let positionAnimation = springAnimationWithKeyPath("position", toValue: NSValue(CGPoint: CGPoint(x: x, y: y)))
            let opacityAnimation = animationWithKeyPath("opacity", toValue: 0.0)
            opacityAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0.9, 0.25, 0.9)
            
            centerNavigationItemView.layer.addAnimation(positionAnimation, forKey: "position")
            centerNavigationItemView.layer.addAnimation(opacityAnimation, forKey: "opacity")
        }
        
        if toViewController.navigationController?.viewControllers.first == toViewController {
            let opacityAnimation = animationWithKeyPath("opacity", toValue: 0.0)
            opacityAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0.9, 0.25, 0.9)
            
            backButtonImageView.layer.addAnimation(opacityAnimation, forKey: "opacity")
        }
    }
    
    func finishAnimation() {
        navigationBar.hidden = false
        
        removeFromSuperview()
    }
}

// MARK: - Private

private extension NavigationBarAnimatorView {
    func springAnimationWithKeyPath(keyPath: String, toValue: NSValue) -> CASpringAnimation {
        let animation = CASpringAnimation(keyPath: keyPath)
        animation.toValue = toValue
        animation.fillMode = kCAFillModeBoth
        animation.duration = 0.5
        animation.damping = 500.0
        animation.stiffness = 1000.0
        animation.mass = 3.0
        animation.removedOnCompletion = false
        
        return animation
    }
    
    func animationWithKeyPath(keyPath: String, toValue: NSValue) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.toValue = toValue
        animation.fillMode = kCAFillModeBoth
        animation.duration = 0.35
        animation.removedOnCompletion = false
        
        return animation
    }
    
    var incomingBackViewController: UIViewController? {
        guard let navigationController = fromViewController.navigationController else {
            return nil
        }
        
        guard let index = navigationController.viewControllers.indexOf(toViewController) where index - 1 >= 0 else {
            return nil
        }
        
        return navigationController.viewControllers[index - 1]
    }
    
    var boundsCenter: CGPoint {
        return CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
    }
}
