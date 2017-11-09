//
//  TeamDetailsViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/16/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import KVOController
import ScoreReporterCore

class TeamDetailsViewController: UIViewController, MessageDisplayable {
    fileprivate let viewModel: TeamDetailsViewModel
    fileprivate let dataSource: TeamDetailsDataSource
    fileprivate let tableView = UITableView(frame: .zero, style: .grouped)
    fileprivate let headerView = TeamDetailsHeaderView(frame: .zero)

    fileprivate var favoriteButton: UIBarButtonItem?
    fileprivate var unfavoriteButton: UIBarButtonItem?

    override var topLayoutGuide: UILayoutSupport {
        configureMessageView(super.topLayoutGuide)

        return messageLayoutGuide
    }

    init(viewModel: TeamDetailsViewModel, dataSource: TeamDetailsDataSource) {
        self.viewModel = viewModel
        self.dataSource = dataSource

        super.init(nibName: nil, bundle: nil)

        title = "Team Details"

        let favoriteImage = UIImage(named: "icn-star")
        favoriteButton = UIBarButtonItem(image: favoriteImage, style: .plain, target: self, action: #selector(favoriteButtonTapped))

        let unfavoriteImage = UIImage(named: "icn-star-selected")
        unfavoriteButton = UIBarButtonItem(image: unfavoriteImage, style: .plain, target: self, action: #selector(unfavoriteButtonTapped))

        navigationItem.rightBarButtonItem = dataSource.team.bookmarked.boolValue ? unfavoriteButton : favoriteButton

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

        dataSource.reloadBlock = { [weak self] changeSet in
            self?.tableView.performUpdates(withChangeSet: changeSet)
        }

        viewModel.downloadTeamDetails { [weak self] _ in
            self?.dataSource.refresh()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !tableView.bounds.width.isEqual(to: headerView.bounds.width) {
            let size = headerView.size(with: tableView.bounds.width)
            headerView.frame = CGRect(origin: .zero, size: size)
            tableView.tableHeaderView = headerView
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        headerView.resetBlurAnimation()
        
        deselectRows(in: tableView, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureObservers()
    }
}

// MARK: - Private

private extension TeamDetailsViewController {
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(headerFooterClass: SectionHeaderView.self)
        tableView.register(cellClass: EventCell.self)
        tableView.register(cellClass: GameCell.self)
        tableView.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        let teamViewModel = TeamViewModel(team: dataSource.team)
        headerView.configure(with: teamViewModel)
    }

    func configureLayout() {
        tableView.edgeAnchors == edgeAnchors
    }

    func configureObservers() {
        kvoController.observe(viewModel, keyPath: #keyPath(TeamDetailsViewModel.loading)) { [weak self] (loading: Bool) in
            if loading {
                self?.display(message: "Loading...", animated: true)
            }
            else {
                self?.hide(animated: true)
            }
        }

        kvoController.observe(viewModel, keyPath: #keyPath(TeamDetailsViewModel.error)) { [weak self] (error: NSError) in
            self?.display(error: error, animated: true)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }

    @objc func favoriteButtonTapped() {
        navigationItem.setRightBarButton(unfavoriteButton, animated: true)

        let team = dataSource.team
        team.bookmarked = true

        do {
            try team.managedObjectContext?.save()
        }
        catch let error {
            print("Error: \(error)")
        }
    }

    @objc func unfavoriteButtonTapped() {
        navigationItem.setRightBarButton(favoriteButton, animated: true)

        let team = dataSource.team
        team.bookmarked = false

        do {
            try team.managedObjectContext?.save()
        }
        catch let error {
            print("Error: \(error)")
        }
    }
    
    @objc func willEnterForeground() {
        headerView.resetBlurAnimation()
    }
}

// MARK: - UITableViewDataSource

extension TeamDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = dataSource.item(at: indexPath) else {
            return UITableViewCell()
        }

        switch item {
        case .event(let event):
            let cell = tableView.dequeueCell(for: indexPath) as EventCell
            cell.configure(with: event)
            cell.separatorHidden = indexPath.item == 0
            return cell
        case .game(let game):
            let gameViewModel = GameViewModel(game: game, state: .full)
            let cell = tableView.dequeueCell(for: indexPath) as GameCell
            cell.configure(with: gameViewModel)
            cell.separatorHidden = indexPath.item == 0
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension TeamDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.item(at: indexPath) else {
            return
        }

        switch item {
        case .event(let event):
            let eventViewModel = EventViewModel(event: event)
            let eventDetailsDataSource = EventDetailsDataSource(viewModel: eventViewModel)
            let eventDetailsViewController = EventDetailsViewController(dataSource: eventDetailsDataSource)
            navigationController?.pushViewController(eventDetailsViewController, animated: true)
        case .game(let game):
            tableView.deselectRow(at: indexPath, animated: true)
            
            let gameDetailsViewModel = GameDetailsViewModel(game: game)
            let gameDetailsViewController = GameDetailsViewController(viewModel: gameDetailsViewModel)
            
            DispatchQueue.main.async {
                self.present(gameDetailsViewController, animated: true, completion: nil)
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = dataSource.headerTitle(for: section) else {
            return nil
        }

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

// MARK: - UIScrollViewDelegate

extension TeamDetailsViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y / -50.0
        let value = min(1.0, max(0.0, offset))
        
        headerView.fractionComplete = value
        headerView.verticalOffset = scrollView.contentOffset.y
    }
}
