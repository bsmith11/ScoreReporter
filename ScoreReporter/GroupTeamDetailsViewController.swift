//
//  GroupTeamDetailsViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 12/10/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import KVOController
import ScoreReporterCore

class GroupTeamDetailsViewController: UIViewController {
    fileprivate let dataSource: GroupTeamDetailsDataSource
    fileprivate let tableView = UITableView(frame: .zero, style: .grouped)
    
    init(dataSource: GroupTeamDetailsDataSource) {
        self.dataSource = dataSource
        
        super.init(nibName: nil, bundle: nil)
        
        title = dataSource.teamName
        
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
        
        dataSource.refreshBlock = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        deselectRows(in: tableView, animated: animated)
    }
}

// MARK: - Private

private extension GroupTeamDetailsViewController {
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellClass: GameCell.self)
        tableView.register(headerFooterClass: SectionHeaderView.self)
        tableView.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    
    func configureLayout() {
        tableView.edgeAnchors == edgeAnchors
    }
}

// MARK: - UITableViewDataSource

extension GroupTeamDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = dataSource.item(at: indexPath)
        let cell = tableView.dequeueCell(for: indexPath) as GameCell
        let gameViewModel = GameViewModel(game: game, state: .full)
        cell.configure(with: gameViewModel)
        cell.separatorHidden = indexPath.item == 0
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension GroupTeamDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let game = dataSource.item(at: indexPath) else {
            return
        }
        
        let gameDetailsViewModel = GameDetailsViewModel(game: game)
        let gameDetailsViewController = GameDetailsViewController(viewModel: gameDetailsViewModel)
        navigationController?.pushViewController(gameDetailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = dataSource.headerTitle(for: section)
        let headerView = tableView.dequeueHeaderFooterView() as SectionHeaderView
        headerView.configure(with: title)
        
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
