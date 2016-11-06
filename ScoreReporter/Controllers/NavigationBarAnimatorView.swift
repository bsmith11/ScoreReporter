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
    
    private var leftFromNavigationButton: NavigationButton?
    private var leftToNavigationButton: NavigationButton?
    
    private var rightFromNavigationButton: NavigationButton?
    private var rightToNavigationButton: NavigationButton?
    
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
        
        rightFromNavigationButton = NavigationButton(viewController: fromViewController, position: .Right)
        
        if let rightFromNavigationButton = rightFromNavigationButton {
            rightFromNavigationButton.center = boundsCenter
            rightFromNavigationButton.frame.origin.x = navigationBar.bounds.width - (5.0 + rightFromNavigationButton.bounds.width)
            addSubview(rightFromNavigationButton)
        }
        
        rightToNavigationButton = NavigationButton(viewController: toViewController, position: .Right)

        if let rightToNavigationButton = rightToNavigationButton {
            rightToNavigationButton.alpha = 0.0
            rightToNavigationButton.center = boundsCenter
            rightToNavigationButton.frame.origin.x = navigationBar.bounds.width - (5.0 + rightToNavigationButton.bounds.width)
            addSubview(rightToNavigationButton)
        }
        
        addSubview(backButtonImageView)
    }
    
    func animateWithDuration(duration: CFTimeInterval, interactive: Bool) {
        let timingFunctionName = interactive ? kCAMediaTimingFunctionLinear : kCAMediaTimingFunctionDefault
        
        if let incomingNavigationItemButtonView = incomingNavigationItemButtonView {
            let x = leadingMargin + (incomingNavigationItemButtonView.layer.bounds.width / 2.0)
            let y = incomingNavigationItemButtonView.layer.position.y
            let position = CGPoint(x: x, y: y)
            
            let positionAnimation = CABasicAnimation(keyPath: "position", timingFunctionName: timingFunctionName, duration: duration)
            positionAnimation.fromValue = NSValue(CGPoint: incomingNavigationItemButtonView.layer.position)
            incomingNavigationItemButtonView.layer.addAnimation(positionAnimation, forKey: "position")
            incomingNavigationItemButtonView.layer.position = position
            
            let timingFunction = CAMediaTimingFunction(controlPoints: 0.75, 0.1, 0.75, 0.1)
            let opacityAnimation = CABasicAnimation(keyPath: "opacity", timingFunction: timingFunction, duration: duration)
            opacityAnimation.fromValue = incomingNavigationItemButtonView.layer.opacity
            incomingNavigationItemButtonView.layer.addAnimation(opacityAnimation, forKey: "opacity")
            incomingNavigationItemButtonView.layer.opacity = 1.0
        }
        
        if let leftNavigationItemButtonView = leftNavigationItemButtonView {
            let position = leftNavigationItemButtonView.centerPosition
            
            let positionAnimation = CABasicAnimation(keyPath: "position", timingFunctionName: timingFunctionName, duration: duration)
            positionAnimation.fromValue = NSValue(CGPoint: leftNavigationItemButtonView.layer.position)
            leftNavigationItemButtonView.layer.addAnimation(positionAnimation, forKey: "position")
            leftNavigationItemButtonView.layer.position = position
            
            let timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0.9, 0.25, 0.9)
            let opacityAnimation = CABasicAnimation(keyPath: "opacity", timingFunction: timingFunction, duration: duration)
            opacityAnimation.fromValue = leftNavigationItemButtonView.layer.opacity
            leftNavigationItemButtonView.layer.addAnimation(opacityAnimation, forKey: "opacity")
            leftNavigationItemButtonView.layer.opacity = 0.0
        }
        
        if let leftNavigationItemView = leftNavigationItemView {
            let position = leftNavigationItemView.centerPosition
            
            let positionAnimation = CABasicAnimation(keyPath: "position", timingFunctionName: timingFunctionName, duration: duration)
            positionAnimation.fromValue = NSValue(CGPoint: leftNavigationItemView.layer.position)
            leftNavigationItemView.layer.addAnimation(positionAnimation, forKey: "position")
            leftNavigationItemView.layer.position = position
            
            let timingFunction = CAMediaTimingFunction(controlPoints: 0.75, 0.1, 0.75, 0.1)
            let opacityAnimation = CABasicAnimation(keyPath: "opacity", timingFunction: timingFunction, duration: duration)
            opacityAnimation.fromValue = leftNavigationItemView.layer.opacity
            leftNavigationItemView.layer.addAnimation(opacityAnimation, forKey: "opacity")
            leftNavigationItemView.layer.opacity = 1.0
        }
        
        if let centerNavigationItemView = centerNavigationItemView {
            let x = navigationBar.frame.maxX + (centerNavigationItemView.layer.bounds.width / 2.0)
            let y = centerNavigationItemView.layer.position.y
            let position = CGPoint(x: x, y: y)
            
            let positionAnimation = CABasicAnimation(keyPath: "position", timingFunctionName: timingFunctionName, duration: duration)
            positionAnimation.fromValue = NSValue(CGPoint: centerNavigationItemView.layer.position)
            centerNavigationItemView.layer.addAnimation(positionAnimation, forKey: "position")
            centerNavigationItemView.layer.position = position
            
            let timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0.9, 0.25, 0.9)
            let opacityAnimation = CABasicAnimation(keyPath: "opacity", timingFunction: timingFunction, duration: duration)
            opacityAnimation.fromValue = centerNavigationItemView.layer.opacity
            centerNavigationItemView.layer.addAnimation(opacityAnimation, forKey: "opacity")
            centerNavigationItemView.layer.opacity = 0.0
        }
        
        if let rightFromNavigationButton = rightFromNavigationButton {
            let opacityAnimation = CABasicAnimation(keyPath: "opacity", timingFunctionName: kCAMediaTimingFunctionDefault, duration: duration)
            opacityAnimation.fromValue = rightFromNavigationButton.layer.opacity
            rightFromNavigationButton.layer.addAnimation(opacityAnimation, forKey: "opacity")
            rightFromNavigationButton.layer.opacity = 0.0
        }
        
        if let rightToNavigationButton = rightToNavigationButton {
            let opacityAnimation = CABasicAnimation(keyPath: "opacity", timingFunctionName: kCAMediaTimingFunctionLinear, duration: duration)
            opacityAnimation.fromValue = rightToNavigationButton.layer.opacity
            rightToNavigationButton.layer.addAnimation(opacityAnimation, forKey: "opacity")
            rightToNavigationButton.layer.opacity = 1.0
        }
        
        if toViewController.navigationController?.viewControllers.first == toViewController {
            let opacityAnimation = CABasicAnimation(keyPath: "opacity", timingFunctionName: kCAMediaTimingFunctionLinear, duration: duration)
            opacityAnimation.fromValue = backButtonImageView.layer.opacity
            backButtonImageView.layer.addAnimation(opacityAnimation, forKey: "opacity")
            backButtonImageView.layer.opacity = 0.0
        }
    }
    
    func finishAnimation() {
        navigationBar.hidden = false
        
        removeFromSuperview()
    }
}

// MARK: - Private

private extension NavigationBarAnimatorView {
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
