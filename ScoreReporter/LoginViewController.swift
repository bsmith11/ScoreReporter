//
//  LoginViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import ScoreReporterCore

class LoginViewController: UIViewController {
    fileprivate let viewModel: LoginViewModel
    fileprivate let contentStackView = UIStackView(frame: .zero)
    fileprivate let emailTextField = UITextField(frame: .zero)
    fileprivate let separatorView = UIView(frame: .zero)
    fileprivate let passwordTextField = UITextField(frame: .zero)
    fileprivate let spacerView = UIView(frame: .zero)
    fileprivate let skipButton = UIButton(type: .system)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        view.backgroundColor = UIColor.scBlue
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(gesture)
        
        configureViews()
        configureLayout()
    }
}

// MARK: - Private

private extension LoginViewController {
    func configureViews() {
        contentStackView.axis = .vertical
        view.addSubview(contentStackView)
        
        let placeholderAttributes = [
            NSForegroundColorAttributeName: UIColor.lightGray
        ]
        
        emailTextField.delegate = self
        emailTextField.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightBlack)
        emailTextField.textColor = UIColor.white
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: placeholderAttributes)
        emailTextField.tintColor = UIColor.white
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.spellCheckingType = .no
        emailTextField.keyboardType = .emailAddress
        contentStackView.addArrangedSubview(emailTextField)
        
        separatorView.backgroundColor = UIColor(hexString: "#C6C6CC")
        contentStackView.addArrangedSubview(separatorView)
        
        passwordTextField.delegate = self
        passwordTextField.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightBlack)
        passwordTextField.textColor = UIColor.white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: placeholderAttributes)
        passwordTextField.tintColor = UIColor.white
        passwordTextField.isSecureTextEntry = true
        contentStackView.addArrangedSubview(passwordTextField)
        
        contentStackView.addArrangedSubview(spacerView)
        
        skipButton.contentEdgeInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        skipButton.setTitle("Later", for: .normal)
        skipButton.setTitleColor(UIColor.white, for: .normal)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightBlack)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
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
                  let password = passwordTextField.text, !username.isEmpty && !password.isEmpty else {
            return
        }
        
        let credentials = Credentials(username: username, password: password)
        
        viewModel.login(with: credentials) { error in
            
        }
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
