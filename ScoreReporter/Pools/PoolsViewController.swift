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
import ScoreReporterCore

class PoolsViewController: UIViewController {
    fileprivate let dataSource: PoolsDataSource
    fileprivate let tableView = InfiniteScrollTableView(frame: .zero, style: .grouped)

    init(dataSource: PoolsDataSource) {
        self.dataSource = dataSource

        super.init(nibName: nil, bundle: nil)

        title = "Pools"

        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
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
        tableView.register(headerFooterClass: SectionHeaderView.self)
        tableView.register(cellClass: StandingCell.self)
        tableView.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }

    func configureLayout() {
        tableView.edgeAnchors == edgeAnchors
    }

    func configureObservers() {
        kvoController.observe(dataSource, keyPath: #keyPath(PoolsDataSource.empty)) { [weak self] (empty: Bool) in
            self?.tableView.empty = empty
        }
    }
}

// MARK: - UITableViewDataSource

extension PoolsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let standing = dataSource.item(at: indexPath)
        let cell = tableView.dequeueCell(for: indexPath) as StandingCell
        cell.configure(with: standing)
        cell.separatorHidden = indexPath.item == 0

        return cell
    }
}

// MARK: - UITableViewDelegate

extension PoolsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let standing = dataSource.item(at: indexPath),
              let group = standing.pool?.round?.group,
              let teamName = standing.teamName else {
            return
        }
        
        let groupTeamDetailsDataSource = GroupTeamDetailsDataSource(group: group, teamName: teamName)
        let groupTeamDetailsViewController = GroupTeamDetailsViewController(dataSource: groupTeamDetailsDataSource)
        navigationController?.pushViewController(groupTeamDetailsViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = dataSource.headerTitle(for: section) else {
            return nil
        }
        
        let headerView = tableView.dequeueHeaderFooterView() as SectionHeaderView
        headerView.configure(with: title, actionButtonTitle: "View")
        headerView.tag = section
        headerView.delegate = self
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let _ = dataSource.headerTitle(for: section) else {
            return 0.0001
        }
        
        return SectionHeaderView.height
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
}

// MARK: - SectionHeaderViewDelegate

extension PoolsViewController: SectionHeaderViewDelegate {
    func didSelectActionButton(in headerView: SectionHeaderView) {
        guard let pool = dataSource.pool(for: headerView.tag) else {
            return
        }

        let gameListDataSource = GameListDataSource(pool: pool)
        let gameListViewController = GameListViewController(dataSource: gameListDataSource)
        navigationController?.pushViewController(gameListViewController, animated: true)
    }
}
