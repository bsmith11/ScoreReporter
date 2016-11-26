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

    fileprivate var favoriteButton: UIBarButtonItem?
    fileprivate var unfavoriteButton: UIBarButtonItem?
    fileprivate var eventCell: UITableViewCell?
    fileprivate var viewDidAppear = false

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let previousColor = navigationController?.navigationBar.barTintColor

        let animation: TransitionCoordinatorBlock = { [weak self] _ in
            self?.navigationController?.navigationBar.barTintColor = UIColor.scBlue
        }

        let completion: TransitionCoordinatorBlock = { [weak self] context in
            if context.isCancelled {
                self?.navigationController?.navigationBar.barTintColor = previousColor
            }

            self?.eventCell?.isHidden = false
        }

        transitionCoordinator?.animate(alongsideTransition: animation, completion: completion)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !viewDidAppear {
            viewDidAppear = true

            configureObservers()
        }
    }
}

// MARK: - Private

private extension EventDetailsViewController {
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(headerFooterClass: SectionHeaderView.self)
        tableView.register(cellClass: EventCell.self)
        tableView.register(cellClass: GroupCell.self)
        tableView.register(cellClass: GameCell.self)
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
        case .event(let event):
            let cell = tableView.dequeueCell(for: indexPath) as EventCell
            eventCell = cell
            cell.isHidden = !viewDidAppear
            cell.configure(with: event)
            cell.separatorHidden = indexPath.item == 0
            return cell
        case .division(let group):
            let groupViewModel = GroupViewModel(group: group)
            let cell = tableView.dequeueCell(for: indexPath) as GroupCell
            cell.configure(with: groupViewModel)
            cell.separatorHidden = true
            return cell
        case .activeGame(let game):
            let gameViewModel = GameViewModel(game: game, state: .Division)
            let cell = tableView.dequeueCell(for: indexPath) as GameCell
            cell.configure(with: gameViewModel)
            cell.separatorHidden = indexPath.item == 0
            return cell
        default:
            return UITableViewCell()
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
        default:
            break
        }
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
