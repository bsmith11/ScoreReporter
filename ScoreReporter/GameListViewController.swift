//
//  GameListViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/25/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import KVOController

class GameListViewController: UIViewController {
    private let dataSource: GameListDataSource
    private let tableView = UITableView(frame: .zero, style: .Plain)
    private let defaultView = DefaultView(frame: .zero)
    
    init(dataSource: GameListDataSource) {
        self.dataSource = dataSource
        
        super.init(nibName: nil, bundle: nil)
        
        title = dataSource.title
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        deselectRowsInTableView(tableView, animated: animated)
    }
}

// MARK: - Private

private extension GameListViewController {
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(GameListCell)
        tableView.registerHeaderFooterClass(SectionHeaderView)
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
        KVOController.observe(dataSource, keyPath: "empty") { [weak self] (empty: Bool) in
            self?.defaultView.empty = empty
        }
    }
}

// MARK: - UITableViewDataSource

extension GameListViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItemsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCellForIndexPath(indexPath) as GameListCell
        let game = dataSource.itemAtIndexPath(indexPath)
        let gameViewModel = GameViewModel(game: game)
        
        cell.configureWithViewModel(gameViewModel)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension GameListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueHeaderFooterView() as SectionHeaderView
        let title = dataSource.titleAtSection(section)

        headerView.configureWithTitle(title)
        
        return headerView
    }
}
