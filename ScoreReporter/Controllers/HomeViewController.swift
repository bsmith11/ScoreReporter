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
        
        title = "Events"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureLayout()
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let animation = { (context: UIViewControllerTransitionCoordinatorContext) -> Void in
            print("")
        }
        
        transitionCoordinator()?.animateAlongsideTransition(animation, completion: nil)
    }
}

// MARK: - Private

private extension HomeViewController {
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(HomeEventCell)
        tableView.registerHeaderFooterClass(HomeSectionHeaderView)
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 44.0
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.alwaysBounceVertical = true
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        view.addSubview(defaultView)
        
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
        let options: NSKeyValueObservingOptions = [
            .Initial,
            .New
        ]
        
        let emptyBlock = { [weak self] (observer: AnyObject?, object: AnyObject, change: [String: AnyObject]) in
            let empty = change[NSKeyValueChangeNewKey] as? Bool ?? false
            self?.defaultView.empty = empty
        }
        
        let loadingBlock = { [weak self] (observer: AnyObject?, object: AnyObject, change: [String: AnyObject]) in
            let loading = change[NSKeyValueChangeNewKey] as? Bool ?? false
            
            if loading {
                self?.displayMessage("Loading...", animated: true)
            }
            else {
                self?.hideMessageAnimated(true)
            }
        }
        
        let errorBlock = { [weak self] (observer: AnyObject?, object: AnyObject, change: [String: AnyObject]) in
            let error = change[NSKeyValueChangeNewKey] as? NSError
            
            if let _ = error {
                self?.displayMessage("Error", animated: true)
            }
        }
        
        KVOController.observe(dataSource, keyPath: "empty", options: options, block: emptyBlock)
        KVOController.observe(viewModel, keyPath: "loading", options: options, block: loadingBlock)
        KVOController.observe(viewModel, keyPath: "error", options: options, block: errorBlock)
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
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueHeaderFooterView() as HomeSectionHeaderView
        let title = dataSource.titleForSection(section)
        
        headerView.configureWithTitle(title)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let event = dataSource.itemAtIndexPath(indexPath) else {
            return
        }
        
        let eventDetailsViewModel = EventDetailsViewModel(event: event)
        let eventDetailsViewController = EventDetailsViewController(viewModel: eventDetailsViewModel)
        
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
