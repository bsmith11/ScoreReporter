//
//  GameDetailsViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 12/10/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import ScoreReporterCore
import Anchorage

class GameDetailsViewController: UIViewController, MessageDisplayable {
    fileprivate let viewModel: GameDetailsViewModel
    
    fileprivate let contentStackView = UIStackView(frame: .zero)
    fileprivate let buttonStackView = UIStackView(frame: .zero)
    
    fileprivate let cancelButton = VisualEffectButton(effect: UIBlurEffect(style: .extraLight))
    fileprivate let updateButton = VisualEffectButton(effect: UIBlurEffect(style: .extraLight))
    
    fileprivate let scorePicker = ScorePicker(frame: .zero)
    
    init(viewModel: GameDetailsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        title = "Game Details"
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.clear
        
        configureViews()
        configureLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureObservers()
        
        scorePicker.set(name: viewModel.game.homeTeamName, for: .home)
        scorePicker.set(name: viewModel.game.awayTeamName, for: .away)
        
        let homeScore = Int(viewModel.game.homeTeamScore) ?? 0
        let awayScore = Int(viewModel.game.awayTeamScore) ?? 0
        
        scorePicker.select(score: homeScore, for: .home)
        scorePicker.select(score: awayScore, for: .away)
    }
}

// MARK: - Public

extension GameDetailsViewController {
    var height: CGFloat {
        let scorePickerSize = scorePicker.size(with: UIScreen.main.bounds.width - 32.0)
        return 16.0 + 44.0 + 8.0 + scorePickerSize.height + 16.0
    }
}

// MARK: - Private

private extension GameDetailsViewController {
    func configureViews() {
        contentStackView.axis = .vertical
        contentStackView.spacing = 8.0
        view.addSubview(contentStackView)
        
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 8.0
        contentStackView.addArrangedSubview(buttonStackView)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        buttonStackView.addArrangedSubview(cancelButton)
        
        updateButton.setTitle("Update", for: .normal)
        updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        buttonStackView.addArrangedSubview(updateButton)
        
        contentStackView.addArrangedSubview(scorePicker)
    }
    
    func configureLayout() {
        contentStackView.edgeAnchors == edgeAnchors + 16.0
        
        cancelButton.heightAnchor == 44.0
        updateButton.heightAnchor == 44.0
    }
    
    func configureObservers() {
        kvoController.observe(viewModel, keyPath: #keyPath(GameDetailsViewModel.loading)) { [weak self] (loading: Bool) in
            self?.updateButton.loading = loading
        }
        
//        kvoController.observe(viewModel, keyPath: #keyPath(GameDetailsViewModel.error)) { [weak self] (error: NSError) in
//            self?.display(error: error, animated: true)
//        }
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func updateButtonTapped() {
        if let _ = ManagedUser.currentUser {
            presentUpdateAlert()
        }
        else {
            presentLogin()
        }
    }
    
    func presentLogin() {
        let loginViewModel = LoginViewModel()
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        let loginNavigationController = BaseNavigationController(rootViewController: loginViewController)
        
        present(loginNavigationController, animated: true, completion: nil)
    }
    
    func presentUpdateAlert() {
        let alertController = UIAlertController(title: "Update Game", message: "Are you sure you want to update this game?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let updateHandler = { [weak self] (action: UIAlertAction) in
            guard let sself = self else {
                return
            }
            
            let homeTeamScore = String(sself.scorePicker.score(for: .home))
            let awayTeamScore = String(sself.scorePicker.score(for: .away))
            let gameStatus = sself.viewModel.game.status.displayValue
            let gameUpdate = GameUpdate(game: sself.viewModel.game, homeTeamScore: homeTeamScore, awayTeamScore: awayTeamScore, gameStatus: gameStatus)
            
            sself.viewModel.update(with: gameUpdate) { [weak self] success in
                if success {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        let confirmAction = UIAlertAction(title: "Update", style: .default, handler: updateHandler)
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension GameDetailsViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return GameDetailsPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
