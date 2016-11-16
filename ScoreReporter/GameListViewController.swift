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
import ScoreReporterCore

class GameListViewController: UIViewController {
    fileprivate let dataSource: GameListDataSource
    fileprivate let tableView = UITableView(frame: .zero, style: .grouped)
    fileprivate let defaultView = DefaultView(frame: .zero)
    
    init(dataSource: GameListDataSource) {
        self.dataSource = dataSource
        
        super.init(nibName: nil, bundle: nil)
        
        title = dataSource.title
        
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
        
        dataSource.fetchedChangeHandler = { [weak self] changes in
            self?.tableView.handle(changes: changes)
        }
    }
}

// MARK: - Private

private extension GameListViewController {
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(headerFooterClass: SectionHeaderView.self)
        tableView.register(cellClass: GameCell.self)
        tableView.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 44.0
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        view.addSubview(defaultView)
    }
    
    func configureLayout() {
        tableView.edgeAnchors == edgeAnchors
        
        defaultView.edgeAnchors == tableView.edgeAnchors
    }
    
    func configureObservers() {
        kvoController.observe(dataSource, keyPath: "empty") { [weak self] (empty: Bool) in
            self?.defaultView.empty = empty
        }
    }
}

// MARK: - UITableViewDataSource

extension GameListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = dataSource.item(at: indexPath)
        let gameViewModel = GameViewModel(game: game)
        
        let cell = tableView.dequeueCell(for: indexPath) as GameCell
        cell.configure(with: gameViewModel)
        cell.separatorHidden = indexPath.item == 0
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension GameListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = dataSource.title(for: section)
        let headerView = tableView.dequeueHeaderFooterView() as SectionHeaderView
        headerView.configure(with: title)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
}
