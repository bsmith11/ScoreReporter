//
//  EventsViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/22/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import KVOController
import ScoreReporterCore

class EventsViewController: UIViewController, MessageDisplayable {
    fileprivate let viewModel: EventsViewModel
    fileprivate let dataSource: EventsDataSource
    fileprivate let tableView = InfiniteScrollTableView(frame: .zero, style: .grouped)
    fileprivate let searchViewController: SearchViewController<Event>

    override var topLayoutGuide: UILayoutSupport {
        configureMessageView(super.topLayoutGuide)

        return messageLayoutGuide
    }

    init(viewModel: EventsViewModel, dataSource: EventsDataSource) {
        self.viewModel = viewModel
        self.dataSource = dataSource

        let searchDataSource = SearchDataSource(fetchedResultsController: Event.searchFetchedResultsController)
        searchViewController = SearchViewController(dataSource: searchDataSource)

        super.init(nibName: nil, bundle: nil)

        searchViewController.delegate = self

        title = "Events"

        let image = UIImage(named: "icn-events")
        let selectedImage = UIImage(named: "icn-events-selected")
        tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        tabBarItem.imageInsets = UIEdgeInsets(top: 5.5, left: 0.0, bottom: -5.5, right: 0.0)

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

        configureViews()
        configureLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureObservers()

        dataSource.fetchedChangeHandler = { [weak self] changes in
            self?.tableView.handle(changes: changes)
        }

        navigationItem.titleView = searchViewController.searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        deselectRows(in: tableView, animated: animated)
    }
}

// MARK: - Private

private extension EventsViewController {
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(headerFooterClass: SectionHeaderView.self)
        tableView.register(cellClass: EventCell.self)
        tableView.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 90.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        view.addSubview(tableView)

        let title = "No Events"
        let message = "Bookmark events for easy access"
        let contentView = EmptyContentView(frame: .zero)
        contentView.configure(withImage: nil, title: title, message: message)
        tableView.emptyView.set(contentView: contentView, forState: .empty)
    }

    func configureLayout() {
        tableView.edgeAnchors == edgeAnchors
    }

    func configureObservers() {
        kvoController.observe(dataSource, keyPath: #keyPath(EventsDataSource.empty)) { [weak self] (empty: Bool) in
            self?.tableView.empty = empty
        }
    }
}

// MARK: - UITableViewDataSource

extension EventsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = dataSource.item(at: indexPath)
        let cell = tableView.dequeueCell(for: indexPath) as EventCell
        cell.configure(with: event)
        cell.separatorHidden = indexPath.item == 0

        return cell
    }
}

// MARK: - UITableViewDelegate

extension EventsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let event = dataSource.item(at: indexPath) else {
            return
        }

        let eventDetailsViewModel = EventDetailsViewModel(event: event)
        let eventDetailsDataSource = EventDetailsDataSource(event: event)
        let eventDetailsViewController = EventDetailsViewController(viewModel: eventDetailsViewModel, dataSource: eventDetailsDataSource)

        navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = dataSource.title(for: section) else {
            return nil
        }

        let headerView = tableView.dequeueHeaderFooterView() as SectionHeaderView
        headerView.configure(with: title)

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let _ = dataSource.title(for: section) else {
            return 0.0001
        }
        
        return SectionHeaderView.height
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
}

// MARK: - SearchViewControllerDelegate

extension EventsViewController: SearchViewControllerDelegate {
    func didSelect(item: Searchable) {
        guard let event = item as? Event else {
            return
        }

        let eventDetailsViewModel = EventDetailsViewModel(event: event)
        let eventDetailsDataSource = EventDetailsDataSource(event: event)
        let eventDetailsViewController = EventDetailsViewController(viewModel: eventDetailsViewModel, dataSource: eventDetailsDataSource)
        navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }

    func didSelectCancel() {
        guard childViewControllers.contains(searchViewController) else {
            return
        }
        
        searchViewController.beginDisappearanceAnimation { [weak self] in
            self?.searchViewController.willMove(toParentViewController: nil)
            self?.searchViewController.view.removeFromSuperview()
            self?.searchViewController.removeFromParentViewController()
        }
    }

    func willBeginEditing() {
        guard !childViewControllers.contains(searchViewController) else {
            return
        }
        
        addChildViewController(searchViewController)
        view.addSubview(searchViewController.view)
        
        searchViewController.view.frame = view.bounds
        searchViewController.view.setNeedsLayout()
        searchViewController.view.layoutIfNeeded()
        
        searchViewController.didMove(toParentViewController: self)
        
        searchViewController.beginAppearanceAnimation(completion: nil)
    }
}
