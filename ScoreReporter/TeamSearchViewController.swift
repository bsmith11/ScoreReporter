//
//  TeamSearchViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import KVOController
import ScoreReporterCore

class TeamSearchViewController: UIViewController, MessageDisplayable {
    fileprivate let viewModel: TeamSearchViewModel
    fileprivate let dataSource: TeamSearchDataSource
    fileprivate let searchBar = UISearchBar(frame: .zero)
    fileprivate let tableView = UITableView(frame: .zero, style: .plain)
    fileprivate let defaultView = DefaultView(frame: .zero)
    
    override var topLayoutGuide: UILayoutSupport {
        configureMessageView(super.topLayoutGuide)
        
        return messageLayoutGuide
    }
    
    init(viewModel: TeamSearchViewModel, dataSource: TeamSearchDataSource) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        
        super.init(nibName: nil, bundle: nil)
        
        title = "Teams"
        
        let image = UIImage(named: "icn-home")
        let selectedImage = UIImage(named: "icn-home-selected")
        tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        tabBarItem.imageInsets = UIEdgeInsets(top: 5.5, left: 0.0, bottom: -5.5, right: 0.0)
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        view = UIView()
        
        configureViews()
        configureLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureObservers()
        
        dataSource.refreshBlock = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.downloadTeams()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        deselectRows(in: tableView, animated: animated)
        
//        let completion = { [weak self] (context: UIViewControllerTransitionCoordinatorContext) in
//            if !context.isCancelled() {
//                self?.searchBar?.becomeFirstResponder()
//            }
//        }
//        
//        transitionCoordinator()?.animateAlongsideTransition(nil, completion: completion)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchBar.resignFirstResponder()
    }
}

// MARK: - Private

private extension TeamSearchViewController {
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellClass: SearchCell.self)
        tableView.register(headerFooterClass: SectionHeaderView.self)
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 44.0
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.white
        tableView.alwaysBounceVertical = true
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        let emptyImage = UIImage(named: "icn-search")
        let emptyTitle = "No Teams"
        let emptyMessage = "No teams exist by that name"
        let emptyInfo = DefaultViewStateInfo(image: emptyImage, title: emptyTitle, message: emptyMessage)
        defaultView.setInfo(emptyInfo, state: .empty)
        view.addSubview(defaultView)
        
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.spellCheckingType = .no
        searchBar.placeholder = "Find teams"
        searchBar.tintColor = UIColor.black
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    func configureLayout() {
        tableView.topAnchor == topLayoutGuide.bottomAnchor
        tableView.horizontalAnchors == horizontalAnchors
        tableView.keyboardLayoutGuide.bottomAnchor == bottomLayoutGuide.topAnchor
        
        defaultView.edgeAnchors == tableView.edgeAnchors
    }
    
    func configureObservers() {
        kvoController.observe(dataSource, keyPath: "empty") { [weak self] (empty: Bool) in
            self?.defaultView.empty = empty
        }
        
        kvoController.observe(viewModel, keyPath: "loading") { [weak self] (loading: Bool) in
            if loading {
                self?.display(message: "Loading...", animated: true)
            }
            else {
                self?.hideMessage(animated: true)
            }
        }
        
        kvoController.observe(viewModel, keyPath: "error") { [weak self] (error: NSError) in
            self?.display(message: "Error", animated: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension TeamSearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(for: indexPath) as SearchCell
        let team = dataSource.item(at: indexPath)
        
        cell.configure(with: team)
        cell.separatorHidden = indexPath.item == 0
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TeamSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueHeaderFooterView() as SectionHeaderView
        let title = dataSource.title(for: section)
        
        headerView.configure(with: title)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let team = dataSource.item(at: indexPath) else {
            return
        }
        
        let teamDetailsViewModel = TeamDetailsViewModel(team: team)
        let teamDetailsDataSource = TeamDetailsDataSource(team: team)
        let teamDetailsViewController = TeamDetailsViewController(viewModel: teamDetailsViewModel, dataSource: teamDetailsDataSource)
        
        navigationController?.pushViewController(teamDetailsViewController, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension TeamSearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        
        dataSource.search(for: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataSource.search(for: searchText)
    }
}
