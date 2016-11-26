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
import KVOController
import SafariServices

protocol LoginViewControllerDelegate: class {
    func didLogin()
}

class LoginViewController: UIViewController {
    fileprivate let viewModel: LoginViewModel
    fileprivate let contentStackView = UIStackView(frame: .zero)
    fileprivate let emailTextField = UITextField(frame: .zero)
    fileprivate let separatorView = UIView(frame: .zero)
    fileprivate let passwordTextField = UITextField(frame: .zero)
    fileprivate let loginButton = UIButton(type: .system)
    fileprivate let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
    fileprivate let forgotPasswordButton = UIButton(type: .system)
    
    weak var delegate: LoginViewControllerDelegate?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
        
        let dismissImage = UIImage(named: "icn-dismiss")
        let dismissButton = UIBarButtonItem(image: dismissImage, style: .plain, target: self, action: #selector(dismissButtonPressed))
        navigationItem.rightBarButtonItem = dismissButton
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.scBlue

        configureViews()
        configureLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        emailTextField.becomeFirstResponder()
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
        emailTextField.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightRegular)
        emailTextField.textColor = UIColor.white
        emailTextField.attributedPlaceholder = NSAttributedString(string: "username", attributes: placeholderAttributes)
        emailTextField.tintColor = UIColor.white
        emailTextField.returnKeyType = .next
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.spellCheckingType = .no
        emailTextField.keyboardType = .emailAddress
        contentStackView.addArrangedSubview(emailTextField)

        separatorView.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.8, alpha: 1.0)
        contentStackView.addArrangedSubview(separatorView)

        passwordTextField.delegate = self
        passwordTextField.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightRegular)
        passwordTextField.textColor = UIColor.white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: placeholderAttributes)
        passwordTextField.tintColor = UIColor.white
        passwordTextField.isSecureTextEntry = true
        passwordTextField.returnKeyType = .go
        contentStackView.addArrangedSubview(passwordTextField)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 28.0, weight: UIFontWeightBlack)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        loginButton.contentEdgeInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        view.addSubview(loginButton)
        
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        
        forgotPasswordButton.setTitle("Forgot Password?", for: .normal)
        forgotPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightRegular)
        forgotPasswordButton.setTitleColor(UIColor.white, for: .normal)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonPressed), for: .touchUpInside)
        forgotPasswordButton.contentEdgeInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        view.addSubview(forgotPasswordButton)
    }

    func configureLayout() {
        contentStackView.topAnchor == topLayoutGuide.bottomAnchor
        contentStackView.horizontalAnchors == horizontalAnchors + 16.0

        emailTextField.heightAnchor == 44.0

        separatorView.heightAnchor == 1.0 / UIScreen.main.scale

        passwordTextField.heightAnchor == 44.0
        
        loginButton.topAnchor == contentStackView.bottomAnchor + 32.0
        loginButton.centerXAnchor == view.centerXAnchor
        
        spinner.centerAnchors == loginButton.centerAnchors
        
        forgotPasswordButton.trailingAnchor == view.trailingAnchor
        forgotPasswordButton.keyboardLayoutGuide.bottomAnchor == view.bottomAnchor
    }
    
    func configureObservers() {
        kvoController.observe(viewModel, keyPath: #keyPath(LoginViewModel.loading)) { [weak self] (loading: Bool) in
            self?.navigationItem.rightBarButtonItem?.isEnabled = !loading
            self?.loginButton.isHidden = loading
            
            if loading {
                self?.spinner.startAnimating()
            }
            else {
                self?.spinner.stopAnimating()
            }
        }
        
        kvoController.observe(viewModel, keyPath: #keyPath(LoginViewModel.error)) { [weak self] (error: NSError) in
            
        }
    }

    @objc func dismissButtonPressed() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func loginButtonPressed() {
        login()
    }
    
    @objc func forgotPasswordButtonPressed() {
        guard let url = URL(string: "https://play.usaultimate.org/members/forgot/") else {
            return
        }
        
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }

    func login() {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.prepare()
        
        guard let username = emailTextField.text, !username.isEmpty else {
            emailTextField.shake()
            feedbackGenerator.notificationOccurred(.error)
            
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            passwordTextField.shake()
            feedbackGenerator.notificationOccurred(.error)
            
            return
        }

        let credentials = Credentials(username: username, password: password)

        viewModel.login(with: credentials) { [weak self] error in
            if error == nil {
                self?.delegate?.didLogin()
                
                self?.emailTextField.resignFirstResponder()
                self?.passwordTextField.resignFirstResponder()
                
                self?.dismiss(animated: true, completion: nil)
            }
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
            login()
        default:
            break
        }

        return true
    }
}
