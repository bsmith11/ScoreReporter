//
//  EventDetailsViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/17/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import KVOController
import ScoreReporterCore

typealias TransitionCoordinatorBlock = (UIViewControllerTransitionCoordinatorContext) -> Void

class EventDetailsViewController: UIViewController, MessageDisplayable {
    fileprivate let viewModel: EventDetailsViewModel
    fileprivate let dataSource: EventDetailsDataSource
    fileprivate let tableView = UITableView(frame: .zero, style: .grouped)
    fileprivate let headerView = EventDetailsHeaderView(frame: .zero)

    fileprivate var favoriteButton: UIBarButtonItem?
    fileprivate var unfavoriteButton: UIBarButtonItem?

    override var topLayoutGuide: UILayoutSupport {
        configureMessageView(super.topLayoutGuide)

        return messageLayoutGuide
    }

    init(viewModel: EventDetailsViewModel, dataSource: EventDetailsDataSource) {
        self.viewModel = viewModel
        self.dataSource = dataSource

        super.init(nibName: nil, bundle: nil)

        title = "Event Details"

        let favoriteImage = UIImage(named: "icn-star")
        favoriteButton = UIBarButtonItem(image: favoriteImage, style: .plain, target: self, action: #selector(favoriteButtonTapped))

        let unfavoriteImage = UIImage(named: "icn-star-selected")
        unfavoriteButton = UIBarButtonItem(image: unfavoriteImage, style: .plain, target: self, action: #selector(unfavoriteButtonTapped))

        navigationItem.rightBarButtonItem = dataSource.event.bookmarked.boolValue ? unfavoriteButton : favoriteButton

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

        viewModel.downloadEventDetails()
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

private extension EventDetailsViewController {
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(headerFooterClass: SectionHeaderView.self)
        tableView.register(cellClass: GroupCell.self)
        tableView.register(cellClass: GameCell.self)
        tableView.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        headerView.configure(with: dataSource.event)
        headerView.delegate = self
    }

    func configureLayout() {
        tableView.edgeAnchors == edgeAnchors
    }

    func configureObservers() {
        kvoController.observe(viewModel, keyPath: #keyPath(EventDetailsViewModel.loading)) { [weak self] (loading: Bool) in
            if loading {
                self?.display(message: "Loading...", animated: true)
            }
            else {
                self?.hide(animated: true)
            }
        }

        kvoController.observe(viewModel, keyPath: #keyPath(EventDetailsViewModel.error)) { [weak self] (error: NSError) in
            self?.display(error: error, animated: true)
        }
    }

    @objc func favoriteButtonTapped() {
        navigationItem.setRightBarButton(unfavoriteButton, animated: true)

        let event = dataSource.event
        event.bookmarked = true

        do {
            try event.managedObjectContext?.save()
        }
        catch let error {
            print("Error: \(error)")
        }
    }

    @objc func unfavoriteButtonTapped() {
        navigationItem.setRightBarButton(favoriteButton, animated: true)

        let event = dataSource.event
        event.bookmarked = false

        do {
            try event.managedObjectContext?.save()
        }
        catch let error {
            print("Error: \(error)")
        }
    }
}

// MARK: - UITableViewDataSource

extension EventDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = dataSource.item(at: indexPath) else {
            return UITableViewCell()
        }

        switch item {
        case .division(let group):
            let groupViewModel = GroupViewModel(group: group)
            let cell = tableView.dequeueCell(for: indexPath) as GroupCell
            cell.configure(with: groupViewModel)
            cell.separatorHidden = indexPath.item == 0
            return cell
        case .activeGame(let game):
            let gameViewModel = GameViewModel(game: game, state: .full)
            let cell = tableView.dequeueCell(for: indexPath) as GameCell
            cell.configure(with: gameViewModel)
            cell.separatorHidden = indexPath.item == 0
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension EventDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.item(at: indexPath) else {
            return
        }

        switch item {
        case .division(let group):
            let groupDetailsDataSource = GroupDetailsDataSource(group: group)
            let groupDetailsViewController = GroupDetailsViewController(dataSource: groupDetailsDataSource)
            navigationController?.pushViewController(groupDetailsViewController, animated: true)
        case .activeGame(let game):
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

extension EventDetailsViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y / -50.0
        let value = min(1.0, max(0.0, offset))

        headerView.fractionComplete = value
        headerView.verticalOffset = scrollView.contentOffset.y
    }
}

// MARK: - EventDetailsHeaderViewDelegate

extension EventDetailsViewController: EventDetailsHeaderViewDelegate {
    func didSelectMaps(in headerView: EventDetailsHeaderView) {
        guard var urlComponenets = URLComponents(string: "http://maps.apple.com/"),
              let address = dataSource.event.searchSubtitle else {
            return
        }
        
        urlComponenets.queryItems = [URLQueryItem(name: "q", value: address)]
        
        if let url = urlComponenets.url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
