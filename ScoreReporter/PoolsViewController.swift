//
//  PoolsViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/24/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import KVOController

class PoolsViewController: UIViewController {
    private let dataSource: PoolsDataSource
    private let tableView = UITableView(frame: .zero, style: .Plain)
    private let defaultView = DefaultView(frame: .zero)
    
    init(dataSource: PoolsDataSource) {
        self.dataSource = dataSource
        
        super.init(nibName: nil, bundle: nil)
        
        title = "Pools"
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        deselectRowsInTableView(tableView, animated: animated)
    }
}

// MARK: - Private

private extension PoolsViewController {
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(StandingCell)
        tableView.registerHeaderFooterClass(PoolsSectionHeaderView)
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
        
        KVOController.observe(dataSource, keyPath: "empty", options: options, block: emptyBlock)
    }
}

// MARK: - UITableViewDataSource

extension PoolsViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItemsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCellForIndexPath(indexPath) as StandingCell
        let standing = dataSource.itemAtIndexPath(indexPath)
        
        cell.configureWithStanding(standing)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PoolsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueHeaderFooterView() as PoolsSectionHeaderView
        let poolSection = dataSource.poolSectionAtSection(section)
        
        headerView.configureWithTitle(poolSection?.title)
        headerView.delegate = self
        headerView.tag = section
        
        return headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

// MARK: - PoolsSectionHeaderViewDelegate

extension PoolsViewController: PoolsSectionHeaderViewDelegate {
    func didSelectSectionHeader(headerView: PoolsSectionHeaderView) {
        guard let pool = dataSource.poolSectionAtSection(headerView.tag)?.pool else {
            return
        }
        
        let gameListDataSource = GameListDataSource(pool: pool)
        let gameListViewController = GameListViewController(dataSource: gameListDataSource)
        navigationController?.pushViewController(gameListViewController, animated: true)
    }
}
