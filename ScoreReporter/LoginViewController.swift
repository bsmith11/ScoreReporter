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
    private let viewModel: LoginViewModel
    private let contentStackView = UIStackView(frame: .zero)
    private let emailTextField = UITextField(frame: .zero)
    private let separatorView = UIView(frame: .zero)
    private let passwordTextField = UITextField(frame: .zero)
    private let spacerView = UIView(frame: .zero)
    private let skipButton = UIButton(type: .System)
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        emailTextField.font = UIFont.systemFontOfSize(20.0, weight: UIFontWeightBlack)
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
        passwordTextField.font = UIFont.systemFontOfSize(20.0, weight: UIFontWeightBlack)
        passwordTextField.textColor = UIColor.whiteColor()
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: placeholderAttributes)
        passwordTextField.tintColor = UIColor.whiteColor()
        passwordTextField.secureTextEntry = true
        contentStackView.addArrangedSubview(passwordTextField)
        
        contentStackView.addArrangedSubview(spacerView)
        
        skipButton.contentEdgeInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        skipButton.setTitle("Later", forState: .Normal)
        skipButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        skipButton.titleLabel?.font = UIFont.systemFontOfSize(18.0, weight: UIFontWeightBlack)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), forControlEvents: .TouchUpInside)
        view.addSubview(skipButton)
    }
    
    func configureLayout() {
        contentStackView.horizontalAnchors == horizontalAnchors + 48.0
        contentStackView.keyboardLayoutGuide.bottomAnchor == bottomLayoutGuide.topAnchor - 100.0
        
        emailTextField.heightAnchor == 44.0
        
        separatorView.heightAnchor == 1.0
        
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
    
    func login() {
        guard let username = emailTextField.text,
                  password = passwordTextField.text where !username.isEmpty && !password.isEmpty else {
            return
        }
        
        let credentials = Credentials(username: username, password: password)
        
        viewModel.loginWithCredentials(credentials) { error in
            
        }
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            print("\(User.currentUser)")
            login()
            break
        default:
            break
        }
        
        return true
    }
}
