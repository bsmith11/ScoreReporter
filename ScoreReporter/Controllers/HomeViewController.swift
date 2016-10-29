//
//  HomeViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import KVOController

class HomeViewController: UIViewController, MessageDisplayable {
    private let viewModel: HomeViewModel
    private let dataSource: HomeDataSource
    
    private let searchDataSource: EventSearchDataSource
    private let searchViewController: EventSearchViewController
    
    private let tableView = UITableView(frame: .zero, style: .Plain)
    private let defaultView = DefaultView(frame: .zero)
    private let searchBar = UISearchBar(frame: .zero)
    
    override var topLayoutGuide: UILayoutSupport {
        configureMessageView(super.topLayoutGuide)
        
        return messageLayoutGuide
    }
    
    init(viewModel: HomeViewModel, dataSource: HomeDataSource) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        
        searchDataSource = EventSearchDataSource()
        searchViewController = EventSearchViewController(dataSource: searchDataSource)
        searchViewController.searchBar = searchBar

        super.init(nibName: nil, bundle: nil)
        
        title = "Home"
        
        let image = UIImage(named: "icn-home")
        let selectedImage = UIImage(named: "icn-home-selected")
        tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func loadView() {
        view = UIView()
        
        configureViews()
        configureLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureObservers()
        
        dataSource.fetchedChangeHandler = { [weak self] changes in
            self?.tableView.handleChanges(changes)
        }
        
        viewModel.downloadEvents()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        deselectRowsInTableView(tableView, animated: animated)
    }
}

// MARK: - Private

private extension HomeViewController {
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(HomeEventCell)
        tableView.registerHeaderFooterClass(SectionHeaderView)
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.alwaysBounceVertical = true
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        let emptyImage = UIImage(named: "icn-home")
        let emptyTitle = "No Events"
        let emptyMessage = "Nothing is happening this week"
        let emptyInfo = DefaultViewStateInfo(image: emptyImage, title: emptyTitle, message: emptyMessage)
        defaultView.setInfo(emptyInfo, state: .Empty)
        view.addSubview(defaultView)
        
        searchBar.autocapitalizationType = .None
        searchBar.autocorrectionType = .No
        searchBar.spellCheckingType = .No
        searchBar.placeholder = "Find events"
        searchBar.tintColor = UIColor.USAUNavyColor()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    func configureLayout() {
        tableView.edgeAnchors == edgeAnchors

        defaultView.edgeAnchors == tableView.edgeAnchors
    }
    
    func configureObservers() {
        KVOController.observe(dataSource, keyPath: "empty") { [weak self] (empty: Bool) in
            self?.defaultView.empty = empty
        }
        
        KVOController.observe(viewModel, keyPath: "loading") { [weak self] (loading: Bool) in
            if loading {
                self?.displayMessage("Loading...", animated: true)
            }
            else {
                self?.hideMessageAnimated(true)
            }
        }
        
        KVOController.observe(viewModel, keyPath: "error") { [weak self] (error: NSError) in
            self?.displayMessage("Error", animated: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItemsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCellForIndexPath(indexPath) as HomeEventCell
        let event = dataSource.itemAtIndexPath(indexPath)
        let eventViewModel = EventViewModel(event: event)
        
        cell.configureWithViewModel(eventViewModel)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        guard let _ = dataSource.titleForSection(section) else {
            return 0.0
        }
        
        return 44.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = dataSource.titleForSection(section) else {
            return nil
        }
        
        let headerView = tableView.dequeueHeaderFooterView() as SectionHeaderView
        headerView.configureWithTitle(title)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let event = dataSource.itemAtIndexPath(indexPath) else {
            return
        }
        
        let eventDetailsViewModel = EventDetailsViewModel(event: event)
        let eventDetailsDataSource = EventDetailsDataSource(event: event)
        let eventDetailsViewController = EventDetailsViewController(viewModel: eventDetailsViewModel, dataSource: eventDetailsDataSource)
        
        navigationController?.pushViewController(eventDetailsViewController, animated: true)        
    }
}

// MARK: - UISearchBarDelegate

extension HomeViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        if !view.subviews.contains(searchViewController.view) {
            addChildViewController(searchViewController)
            searchViewController.view.frame = view.bounds
            view.addSubview(searchViewController.view)
            searchViewController.didMoveToParentViewController(self)
            
            searchViewController.view.setNeedsLayout()
            searchViewController.view.layoutIfNeeded()
        }
        
        searchBar.setShowsCancelButton(true, animated: true)
        
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        
        searchDataSource.searchWithText(nil)
        
        searchViewController.willMoveToParentViewController(nil)
        searchViewController.view.removeFromSuperview()
        searchViewController.removeFromParentViewController()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchDataSource.searchWithText(searchText)
    }
}
