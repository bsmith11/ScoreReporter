//
//  LoginViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

class LoginViewController: UIViewController {
    private let contentStackView = UIStackView(frame: .zero)
    private let emailTextField = UITextField(frame: .zero)
    private let separatorView = UIView(frame: .zero)
    private let passwordTextField = UITextField(frame: .zero)
    private let spacerView = UIView(frame: .zero)
    private let skipButton = UIButton(type: .System)
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.USAUNavyColor()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(gesture)
        
        configureViews()
        configureLayout()
    }
}

// MARK: - Private

private extension LoginViewController {
    func configureViews() {
        contentStackView.axis = .Vertical
        view.addSubview(contentStackView)
        
        let placeholderAttributes = [
            NSForegroundColorAttributeName: UIColor.lightGrayColor()
        ]
        
        emailTextField.delegate = self
        emailTextField.font = UIFont.systemFontOfSize(20.0, weight: UIFontWeightThin)
        emailTextField.textColor = UIColor.whiteColor()
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: placeholderAttributes)
        emailTextField.tintColor = UIColor.whiteColor()
        emailTextField.autocapitalizationType = .None
        emailTextField.autocorrectionType = .No
        emailTextField.spellCheckingType = .No
        emailTextField.keyboardType = .EmailAddress
        contentStackView.addArrangedSubview(emailTextField)
        
        separatorView.backgroundColor = UIColor(hexString: "#C6C6CC")
        contentStackView.addArrangedSubview(separatorView)
        
        passwordTextField.delegate = self
        passwordTextField.font = UIFont.systemFontOfSize(20.0, weight: UIFontWeightThin)
        passwordTextField.textColor = UIColor.whiteColor()
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: placeholderAttributes)
        passwordTextField.tintColor = UIColor.whiteColor()
        passwordTextField.secureTextEntry = true
        contentStackView.addArrangedSubview(passwordTextField)
        
        contentStackView.addArrangedSubview(spacerView)
        
        skipButton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        skipButton.setTitle("Login Later", forState: .Normal)
        skipButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        skipButton.titleLabel?.font = UIFont.systemFontOfSize(18.0, weight: UIFontWeightThin)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), forControlEvents: .TouchUpInside)
        view.addSubview(skipButton)
    }
    
    func configureLayout() {
        contentStackView.horizontalAnchors == horizontalAnchors + 60.0
        contentStackView.keyboardLayoutGuide.bottomAnchor == bottomLayoutGuide.topAnchor - 100.0
        
        emailTextField.heightAnchor == 44.0
        
        separatorView.heightAnchor == 1.0//(1.0 / UIScreen.mainScreen().scale)
        
        passwordTextField.heightAnchor == 44.0
        
        spacerView.heightAnchor == 60.0
        
        skipButton.trailingAnchor == view.trailingAnchor
        skipButton.keyboardLayoutGuide.bottomAnchor == bottomLayoutGuide.topAnchor
    }
    
    @objc func handleTap() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @objc func skipButtonTapped() {
        
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            //TODO: - Login
            break
        default:
            break
        }
        
        return true
    }
}
