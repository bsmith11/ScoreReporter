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
    fileprivate let dataSource: PoolsDataSource
    fileprivate let tableView = UITableView(frame: .zero, style: .plain)
    fileprivate let defaultView = DefaultView(frame: .zero)
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        deselectRows(in: tableView, animated: animated)
    }
}

// MARK: - Private

private extension PoolsViewController {
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellClass: StandingCell.self)
        tableView.register(headerFooterClass: SectionHeaderView.self)
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 44.0
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.white
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
        kvoController.observe(dataSource, keyPath: "empty") { [weak self] (empty: Bool) in
            self?.defaultView.empty = empty
        }
    }
}

// MARK: - UITableViewDataSource

extension PoolsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(for: indexPath) as StandingCell
        let standing = dataSource.item(at: indexPath)
        
        cell.configure(with: standing)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PoolsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueHeaderFooterView() as SectionHeaderView
        let poolSection = dataSource.poolSection(at: section)
        
        headerView.configure(with: poolSection?.title, tappable: true)
        headerView.delegate = self
        headerView.tag = section
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - SectionHeaderViewDelegate

extension PoolsViewController: SectionHeaderViewDelegate {
    func didSelectSectionHeader(_ headerView: SectionHeaderView) {
        guard let pool = dataSource.poolSection(at: headerView.tag)?.pool else {
            return
        }
        
        let gameListDataSource = GameListDataSource(pool: pool)
        let gameListViewController = GameListViewController(dataSource: gameListDataSource)
        navigationController?.pushViewController(gameListViewController, animated: true)
    }
}
