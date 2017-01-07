//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Bradley Smith on 11/15/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import NotificationCenter
import ScoreReporterCore
import Anchorage
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding {
    fileprivate let viewModel = TodayViewModel()
    fileprivate let dataSource = TodayDataSource()
    fileprivate let tableView = UITableView(frame: .zero, style: .plain)
    fileprivate let headerView = TodayTeamHeaderView(frame: .zero)
    fileprivate let defaultView = DefaultView(frame: .zero)

    override func loadView() {
        view = UIView()

        configureViews()
        configureLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let emptyMessage: String
        if let team = dataSource.team {
            if let name = team.fullName {
                emptyMessage = "\(name) has no upcoming events or games"
            }
            else {
                emptyMessage = "No upcoming events or games"
            }
        }
        else {
            emptyMessage = "Favorite a team to see their upcoming events and games"

        }

        let emptyInfo = DefaultViewStateInfo(image: nil, title: nil, message: emptyMessage)
        defaultView.set(info: emptyInfo, state: .empty)
        defaultView.empty = dataSource.empty

        extensionContext?.widgetLargestAvailableDisplayMode = dataSource.empty ? .compact : .expanded
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size = headerView.size(with: tableView.bounds.width)
        headerView.frame = CGRect(origin: .zero, size: size)
        tableView.tableHeaderView = headerView
    }

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode {
        case .compact:
            preferredContentSize = maxSize
        case .expanded:
            preferredContentSize = maxSize
        }
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
//        let teamService = TeamService(client: APIClient.sharedInstance)
//        teamService.downloadDetails(for: team, completion: { error in
//            let result: NCUpdateResult = (error == nil) ? .newData : .failed
//            completionHandler(result)
//        })

        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
    }
}

// MARK: - Private

private extension TodayViewController {
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellClass: TodayEventCell.self)
        tableView.register(cellClass: GameCell.self)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        view.addSubview(tableView)
        
        if let team = dataSource.team {
            headerView.configure(with: team)
        }

        defaultView.tintColor = UIColor.darkGray
        view.addSubview(defaultView)
    }

    func configureLayout() {
        tableView.edgeAnchors == edgeAnchors

        defaultView.edgeAnchors == tableView.edgeAnchors
    }
}

// MARK: - UITableViewDataSource

extension TodayViewController: UITableViewDataSource {
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
        case .game(let game):
            let gameViewModel = GameViewModel(game: game, state: .minimal)
            let cell = tableView.dequeueCell(for: indexPath) as GameCell
            cell.configure(with: gameViewModel)
            cell.separatorHidden = indexPath.item == 0
            return cell
        case .event(let event):
            let cell = tableView.dequeueCell(for: indexPath) as TodayEventCell
            cell.configure(with: event)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension TodayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.item(at: indexPath) else {
            return
        }
        
        switch item {
        case .event(let event):
            if let url = URL(string: "scrreporter://events/\(event.eventID.intValue)") {
                extensionContext?.open(url, completionHandler: nil)
            }
        case .game(let game):
            if let url = URL(string: "scrreporter://games/\(game.gameID.intValue)") {
                extensionContext?.open(url, completionHandler: nil)
            }
        }
    }
}
