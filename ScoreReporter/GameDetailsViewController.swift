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
    
    fileprivate let pickerStackView = UIStackView(frame: .zero)
    fileprivate let homeScorePickerView = UIPickerView(frame: .zero)
    fileprivate let awayScorePickerView = UIPickerView(frame: .zero)
    
    fileprivate let pickerStackViewCover = UIView(frame: .zero)
    
    fileprivate let teamStackView = UIStackView(frame: .zero)
    fileprivate let homeLabel = UILabel(frame: .zero)
    fileprivate let awayLabel = UILabel(frame: .zero)
    
    fileprivate let editButton = UIBarButtonItem()
    fileprivate let cancelButton = UIBarButtonItem()
    fileprivate let saveButton = UIBarButtonItem()
    fileprivate let loadingButton = UIBarButtonItem()
    fileprivate let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    fileprivate var contentStackViewTop: NSLayoutConstraint?
    fileprivate var pickerViewOffset: CGFloat {
        let pickerHeight = CGFloat(160.0)
        let rowHeight = homeScorePickerView.rowSize(forComponent: 0).height
        let offset = max(0.0, (pickerHeight - rowHeight)) / 2.0
                
        return ceil(offset)
    }
    
    override var topLayoutGuide: UILayoutSupport {
        configureMessageView(super.topLayoutGuide)
        
        return messageLayoutGuide
    }
    
    init(viewModel: GameDetailsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        title = "Game Details"
        
        editButton.title = "Edit"
        editButton.target = self
        editButton.action = #selector(editButtonTapped)
        editButton.isEnabled = User.currentUser != nil
        
        cancelButton.title = "Cancel"
        cancelButton.target = self
        cancelButton.action = #selector(cancelButtonTapped)
        
        saveButton.title = "Save"
        saveButton.target = self
        saveButton.action = #selector(saveButtonTapped)
        
        spinner.hidesWhenStopped = true
        loadingButton.customView = spinner
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        
        configureViews()
        configureLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureObservers()
        
        let homeScore = viewModel.game.homeTeamScore.flatMap { Int($0) } ?? 0
        let awayScore = viewModel.game.awayTeamScore.flatMap { Int($0) } ?? 0
        
        homeScorePickerView.selectRow(homeScore, inComponent: 0, animated: false)
        awayScorePickerView.selectRow(awayScore, inComponent: 0, animated: false)
        
        set(editing: false, animated: false)
    }
}

// MARK: - Private

private extension GameDetailsViewController {
    func configureViews() {
        contentStackView.axis = .vertical
        view.addSubview(contentStackView)
        
        pickerStackView.axis = .horizontal
        pickerStackView.spacing = 16.0
        pickerStackView.distribution = .fillEqually
        contentStackView.addArrangedSubview(pickerStackView)
        
        homeScorePickerView.dataSource = self
        homeScorePickerView.delegate = self
        homeScorePickerView.backgroundColor = UIColor.white
        pickerStackView.addArrangedSubview(homeScorePickerView)
        
        awayScorePickerView.dataSource = self
        awayScorePickerView.delegate = self
        awayScorePickerView.backgroundColor = UIColor.white
        pickerStackView.addArrangedSubview(awayScorePickerView)
        
        pickerStackViewCover.alpha = 0.0
        pickerStackViewCover.backgroundColor = UIColor.white
        pickerStackViewCover.isUserInteractionEnabled = false
        pickerStackView.addSubview(pickerStackViewCover)
        
        teamStackView.axis = .horizontal
        teamStackView.spacing = 16.0
        teamStackView.distribution = .fillEqually
        teamStackView.alignment = .firstBaseline
        contentStackView.addArrangedSubview(teamStackView)
        
        homeLabel.text = viewModel.game.homeTeamName
        homeLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightBlack)
        homeLabel.textColor = UIColor.black
        homeLabel.numberOfLines = 0
        homeLabel.lineBreakMode = .byWordWrapping
        homeLabel.textAlignment = .center
        teamStackView.addArrangedSubview(homeLabel)
        
        awayLabel.text = viewModel.game.awayTeamName
        awayLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightBlack)
        awayLabel.textColor = UIColor.black
        awayLabel.numberOfLines = 0
        awayLabel.lineBreakMode = .byWordWrapping
        awayLabel.textAlignment = .center
        teamStackView.addArrangedSubview(awayLabel)
    }
    
    func configureLayout() {
        contentStackViewTop = contentStackView.topAnchor == topLayoutGuide.bottomAnchor
        contentStackView.horizontalAnchors == horizontalAnchors + 16.0
        
        pickerStackView.heightAnchor == 160.0
        
        pickerStackViewCover.horizontalAnchors == pickerStackView.horizontalAnchors
        pickerStackViewCover.bottomAnchor == pickerStackView.bottomAnchor
        pickerStackViewCover.heightAnchor == 46.0
    }
    
    func configureObservers() {
        kvoController.observe(viewModel, keyPath: #keyPath(GameDetailsViewModel.loading)) { [weak self] (loading: Bool) in
            if loading {
                self?.spinner.startAnimating()
                self?.navigationItem.setRightBarButton(self?.loadingButton, animated: true)
            }
            else {
                self?.spinner.stopAnimating()
                self?.navigationItem.setRightBarButton(self?.editButton, animated: true)
            }            
        }
        
        kvoController.observe(viewModel, keyPath: #keyPath(GameDetailsViewModel.error)) { [weak self] (error: NSError) in
            self?.display(error: error, animated: true)
        }
    }
    
    @objc func editButtonTapped() {
        set(editing: true, animated: true)
    }
    
    @objc func cancelButtonTapped() {
        set(editing: false, animated: true)
    }
    
    @objc func saveButtonTapped() {
        set(editing: false, animated: true)
        
        hide(animated: true)
        
        let homeTeamScore = String(homeScorePickerView.selectedRow(inComponent: 0))
        let awayTeamScore = String(awayScorePickerView.selectedRow(inComponent: 0))
        let gameStatus = viewModel.game.status ?? "Scheduled"
        let gameUpdate = GameUpdate(game: viewModel.game, homeTeamScore: homeTeamScore, awayTeamScore: awayTeamScore, gameStatus: gameStatus)
        
        viewModel.update(with: gameUpdate)
    }
}

// MARK: - UIPickerViewDataSource

extension GameDetailsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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

// MARK: - Animations

private extension GameDetailsViewController {
    func set(editing: Bool, animated: Bool) {
        pickerStackView.isUserInteractionEnabled = editing
        baseNavigationController?.interactionControllerEnabled = !editing
        
        let offset = pickerViewOffset
        let top = editing ? 0.0 : -offset
        let spacing = editing ? 0.0 : -offset
        let alpha: CGFloat = editing ? 0.0 : 1.0
        
        contentStackViewTop?.constant = top
        contentStackView.spacing = spacing
        
        let animations = {
            self.pickerStackViewCover.alpha = alpha
            self.view.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: animations)
        }
        else {
            animations()
        }
        
        let leftButton = editing ? cancelButton : nil
        let rightButton = editing ? saveButton : editButton
        
        navigationItem.setLeftBarButton(leftButton, animated: animated)
        navigationItem.setRightBarButton(rightButton, animated: animated)
    }
}
