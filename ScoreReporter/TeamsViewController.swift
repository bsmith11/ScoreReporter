//
//  TeamsViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/22/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import KVOController
import ScoreReporterCore

class TeamsViewController: UIViewController, MessageDisplayable {
    fileprivate let viewModel: TeamsViewModel
    fileprivate let dataSource: TeamsDataSource
    fileprivate let tableView = UITableView(frame: .zero, style: .grouped)
    fileprivate let defaultView = DefaultView(frame: .zero)
    
    fileprivate var selectedCell: UITableViewCell?
    
    override var topLayoutGuide: UILayoutSupport {
        configureMessageView(super.topLayoutGuide)
        
        return messageLayoutGuide
    }
    
    init(viewModel: TeamsViewModel, dataSource: TeamsDataSource) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        
        super.init(nibName: nil, bundle: nil)
        
        title = "Teams"
        
        let image = UIImage(named: "icn-teams")
        let selectedImage = UIImage(named: "icn-teams-selected")
        tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        tabBarItem.imageInsets = UIEdgeInsets(top: 5.5, left: 0.0, bottom: -5.5, right: 0.0)
        
        let searchButton = UIBarButtonItem(image: UIImage(named: "icn-search"), style: .plain, target: self, action: #selector(searchButtonPressed))
        navigationItem.rightBarButtonItem = searchButton
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        transitionCoordinator?.animate(alongsideTransition: nil, completion: { [weak self] _ in
            self?.selectedCell?.isHidden = false
        })
    }
}

// MARK: - Private

private extension TeamsViewController {
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellClass: TeamCell.self)
        tableView.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 90.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        let emptyTitle = "No Teams"
        let emptyMessage = "Bookmark teams for easy access"
        let emptyInfo = DefaultViewStateInfo(image: nil, title: emptyTitle, message: emptyMessage)
        defaultView.setInfo(emptyInfo, state: .empty)
        view.addSubview(defaultView)
    }
    
    func configureLayout() {
        tableView.edgeAnchors == edgeAnchors
        
        defaultView.edgeAnchors == tableView.edgeAnchors
    }
    
    func configureObservers() {
        kvoController.observe(dataSource, keyPath: #keyPath(TeamsDataSource.empty)) { [weak self] (empty: Bool) in
            self?.defaultView.empty = empty
        }
    }
    
    @objc func searchButtonPressed() {
        let searchDataSource = SearchDataSource(fetchedResultsController: Team.searchFetchedResultsController)
        let searchViewController = SearchViewController(dataSource: searchDataSource)
        searchViewController.delegate = self
        navigationController?.pushViewController(searchViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension TeamsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let team = dataSource.item(at: indexPath)
        let cell = tableView.dequeueCell(for: indexPath) as TeamCell
        cell.configure(with: team)
        cell.separatorHidden = indexPath.item == 0
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TeamsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let team = dataSource.item(at: indexPath) else {
            return
        }
        
        selectedCell = tableView.cellForRow(at: indexPath)
        
        let teamDetailsViewModel = TeamDetailsViewModel(team: team)
        let teamDetailsDataSource = TeamDetailsDataSource(team: team)
        let teamDetailsViewController = TeamDetailsViewController(viewModel: teamDetailsViewModel, dataSource: teamDetailsDataSource)
        navigationController?.pushViewController(teamDetailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
}

// MARK: - SearchViewControllerDelegate

extension TeamsViewController: SearchViewControllerDelegate {
    func didSelect(item: Searchable) {
        guard let team = item as? Team else {
            return
        }
        
        let teamDetailsViewModel = TeamDetailsViewModel(team: team)
        let teamDetailsDataSource = TeamDetailsDataSource(team: team)
        let teamDetailsViewController = TeamDetailsViewController(viewModel: teamDetailsViewModel, dataSource: teamDetailsDataSource)
        navigationController?.pushViewController(teamDetailsViewController, animated: true)
    }
}

// MARK: - ListDetailAnimationControllerDelegate

extension TeamsViewController: ListDetailAnimationControllerDelegate {
    var viewToAnimate: UIView {
        guard let cell = selectedCell as? TeamCell,
            let navView = navigationController?.view,
            let snapshot = cell.snapshot(rect: cell.contentFrame) else {
                return UIView()
        }
        
        let frame = cell.contentFrameFrom(view: navView)
        snapshot.frame = frame
        
        cell.isHidden = true
        
        return snapshot
    }
    
    func shouldAnimate(to viewController: UIViewController) -> Bool {
        return viewController is TeamDetailsViewController
    }
}
