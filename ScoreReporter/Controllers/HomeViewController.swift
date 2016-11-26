//
//  HomeViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import KVOController
import ScoreReporterCore

class HomeViewController: UIViewController, MessageDisplayable {
    fileprivate let viewModel: HomeViewModel
    fileprivate let dataSource: HomeDataSource
    fileprivate let tableView = UITableView(frame: .zero, style: .grouped)
    fileprivate let defaultView = DefaultView(frame: .zero)

    override var topLayoutGuide: UILayoutSupport {
        configureMessageView(super.topLayoutGuide)

        return messageLayoutGuide
    }

    init(viewModel: HomeViewModel, dataSource: HomeDataSource) {
        self.viewModel = viewModel
        self.dataSource = dataSource

        super.init(nibName: nil, bundle: nil)

        title = "Home"

        let image = UIImage(named: "icn-home")
        let selectedImage = UIImage(named: "icn-home-selected")
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
        view.backgroundColor = UIColor.white

        configureViews()
        configureLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureObservers()

        dataSource.fetchedChangeHandler = { [weak self] changes in
            self?.tableView.handle(changes: changes)
        }

//        viewModel.downloadEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        deselectRows(in: tableView, animated: animated)
    }
}

// MARK: - Private

private extension HomeViewController {
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(headerFooterClass: SectionHeaderView.self)
        tableView.register(cellClass: EventCell.self)
        tableView.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        view.addSubview(tableView)

        let emptyTitle = "No Events"
        let emptyMessage = "Nothing is happening this week"
        let emptyInfo = DefaultViewStateInfo(image: nil, title: emptyTitle, message: emptyMessage)
        defaultView.setInfo(emptyInfo, state: .empty)
        view.addSubview(defaultView)
    }

    func configureLayout() {
        tableView.edgeAnchors == edgeAnchors

        defaultView.edgeAnchors == tableView.edgeAnchors
    }

    func configureObservers() {
        kvoController.observe(dataSource, keyPath: #keyPath(HomeDataSource.empty)) { [weak self] (empty: Bool) in
            self?.defaultView.empty = empty
        }

        kvoController.observe(viewModel, keyPath: #keyPath(HomeViewModel.loading)) { [weak self] (loading: Bool) in
            if loading {
                self?.display(message: "Loading...", animated: true)
            }
            else {
                self?.hide(animated: true)
            }
        }

        kvoController.observe(viewModel, keyPath: #keyPath(HomeViewModel.error)) { [weak self] (error: NSError) in
            self?.display(error: error, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
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

extension HomeViewController: UITableViewDelegate {
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
        let title = dataSource.title(for: section)
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
