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
    
    fileprivate let cancelContainerView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    fileprivate let cancelButton = UIButton(type: .system)
    
    fileprivate let updateContainerView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    fileprivate let updateButton = UIButton(type: .system)
    
    fileprivate let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    fileprivate let pickerContainerView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    fileprivate let pickerStackView = UIStackView(frame: .zero)
    
    fileprivate let labelStackView = UIStackView(frame: .zero)
    fileprivate let homeLabel = UILabel(frame: .zero)
    fileprivate let awayLabel = UILabel(frame: .zero)
    
    fileprivate let pickerView = UIPickerView(frame: .zero)
    
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
        
        let homeScore = viewModel.game.homeTeamScore.flatMap { Int($0) } ?? 0
        let awayScore = viewModel.game.awayTeamScore.flatMap { Int($0) } ?? 0
        
        pickerView.selectRow(homeScore, inComponent: 0, animated: false)
        pickerView.selectRow(awayScore, inComponent: 1, animated: false)
    }
}

// MARK: - Public

extension GameDetailsViewController {
    var height: CGFloat {
        return 16.0 + 44.0 + 8.0 + 16.0 + homeLabel.font.lineHeight + 160.0 + 16.0
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
        
        cancelContainerView.layer.cornerRadius = 12.0
        cancelContainerView.layer.masksToBounds = true
        cancelContainerView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        cancelContainerView.layer.borderWidth = (1.0 / UIScreen.main.scale)
        buttonStackView.addArrangedSubview(cancelContainerView)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightBlack)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelContainerView.addSubview(cancelButton)
        
        updateContainerView.layer.cornerRadius = 12.0
        updateContainerView.layer.masksToBounds = true
        updateContainerView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        updateContainerView.layer.borderWidth = (1.0 / UIScreen.main.scale)
        buttonStackView.addArrangedSubview(updateContainerView)
        
        updateButton.setTitle("Update", for: .normal)
        updateButton.setTitleColor(UIColor.black, for: .normal)
        updateButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightBlack)
        updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        updateContainerView.addSubview(updateButton)
        
        spinner.hidesWhenStopped = true
        spinner.color = UIColor.black
        updateContainerView.addSubview(spinner)
        
        pickerContainerView.layer.cornerRadius = 12.0
        pickerContainerView.layer.masksToBounds = true
        pickerContainerView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        pickerContainerView.layer.borderWidth = (1.0 / UIScreen.main.scale)
        contentStackView.addArrangedSubview(pickerContainerView)
        
        pickerStackView.axis = .vertical
        pickerContainerView.addSubview(pickerStackView)
        
        labelStackView.axis = .horizontal
        labelStackView.spacing = 8.0
        labelStackView.distribution = .fillEqually
        labelStackView.alignment = .firstBaseline
        pickerStackView.addArrangedSubview(labelStackView)
        
        homeLabel.text = viewModel.game.homeTeamName
        homeLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightRegular)
        homeLabel.textColor = UIColor.black
        homeLabel.textAlignment = .center
        labelStackView.addArrangedSubview(homeLabel)
        
        awayLabel.text = viewModel.game.awayTeamName
        awayLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightRegular)
        awayLabel.textColor = UIColor.black
        awayLabel.textAlignment = .center
        labelStackView.addArrangedSubview(awayLabel)
        
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerStackView.addArrangedSubview(pickerView)
    }
    
    func configureLayout() {
        contentStackView.edgeAnchors == edgeAnchors + 16.0
        
        cancelContainerView.heightAnchor == 44.0
        cancelButton.edgeAnchors == cancelContainerView.edgeAnchors
        
        updateContainerView.heightAnchor == 44.0
        updateButton.edgeAnchors == updateContainerView.edgeAnchors
        spinner.centerAnchors == updateContainerView.centerAnchors
        
        pickerStackView.topAnchor == pickerContainerView.topAnchor + 16.0
        pickerStackView.horizontalAnchors == pickerContainerView.horizontalAnchors
        pickerStackView.bottomAnchor == pickerContainerView.bottomAnchor
        pickerView.heightAnchor == 160.0
    }
    
    func configureObservers() {
        kvoController.observe(viewModel, keyPath: #keyPath(GameDetailsViewModel.loading)) { [weak self] (loading: Bool) in
            guard let sself = self else {
                return
            }
            
            if loading {
                sself.spinner.startAnimating()
                sself.updateButton.isHidden = true
            }
            else {
                sself.spinner.stopAnimating()
                sself.updateButton.isHidden = false
            }
        }
        
//        kvoController.observe(viewModel, keyPath: #keyPath(GameDetailsViewModel.error)) { [weak self] (error: NSError) in
//            self?.display(error: error, animated: true)
//        }
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func updateButtonTapped() {
        if let _ = User.currentUser {
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
            
            let homeTeamScore = String(sself.pickerView.selectedRow(inComponent: 0))
            let awayTeamScore = String(sself.pickerView.selectedRow(inComponent: 1))
            let gameStatus = sself.viewModel.game.status ?? "Scheduled"
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

// MARK: - UIPickerViewDataSource

extension GameDetailsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 99
    }
}

// MARK: - UIPickerViewDelegate

extension GameDetailsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel(frame: .zero)
        label.text = String(row)
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 44.0, weight: UIFontWeightBlack)
        label.textAlignment = .center
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return UIFont.systemFont(ofSize: 44.0, weight: UIFontWeightBlack).lineHeight + 16.0
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension GameDetailsViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return GameDetailsPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
