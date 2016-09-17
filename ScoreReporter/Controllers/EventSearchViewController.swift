//
//  EventSearchViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

class EventSearchViewController: UIViewController {
    private let viewModel: EventSearchViewModel
    private let tableView = UITableView(frame: .zero, style: .Plain)
    private let defaultView = DefaultView(frame: .zero)
    
    var searchBar: UISearchBar?
    
    init(viewModel: EventSearchViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        
        configureViews()
        configureLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureObservers()
        
        viewModel.refreshBlock = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        deselectRowsInTableView(tableView, animated: animated)
        
        let completion = { [weak self] (context: UIViewControllerTransitionCoordinatorContext) in
            if !context.isCancelled() {
                self?.searchBar?.becomeFirstResponder()
            }
        }
        
        transitionCoordinator()?.animateAlongsideTransition(nil, completion: completion)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchBar?.resignFirstResponder()
    }
}

// MARK: - Private

private extension EventSearchViewController {
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(HomeEventCell.self)
        tableView.registerHeaderFooterClass(HomeHeaderView.self)
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 44.0
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.alwaysBounceVertical = true
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        view.addSubview(defaultView)
    }
    
    func configureLayout() {
        tableView.topAnchor == topLayoutGuide.bottomAnchor
        tableView.horizontalAnchors == horizontalAnchors
        tableView.keyboardLayoutGuide.bottomAnchor == bottomLayoutGuide.topAnchor
        
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
        
        KVOController.observe(viewModel, keyPath: "empty", options: options, block: emptyBlock)
    }
}

// MARK: - UITableViewDataSource

extension EventSearchViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCellForIndexPath(indexPath) as HomeEventCell
        let event = viewModel.itemAtIndexPath(indexPath)
        let eventViewModel = EventViewModel(event: event)
        
        cell.configureWithViewModel(eventViewModel)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension EventSearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueHeaderFooterView() as HomeHeaderView
        let indexPath = NSIndexPath(forRow: 0, inSection: section)
        let event = viewModel.itemAtIndexPath(indexPath)
        let eventViewModel = EventViewModel(event: event)
        
        headerView.configureWithViewModel(eventViewModel)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let event = viewModel.itemAtIndexPath(indexPath)
        let eventViewModel = EventViewModel(event: event)
        let eventViewController = EventViewController(viewModel: eventViewModel)
        
        navigationController?.pushViewController(eventViewController, animated: true)
    }
}
