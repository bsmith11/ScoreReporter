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
    fileprivate let tableView = UITableView(frame: .zero, style: .plain)
    fileprivate let defaultView = DefaultView(frame: .zero)

    fileprivate var event: Event?
    fileprivate var games: [Game]?
    
    override func loadView() {
        view = UIView()
        
        configureViews()
        configureLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        event = Event.fetchedBookmarkedEvents().fetchedObjects?.first
        
        let pool = Pool.object(primaryKey: 8174, context: Pool.coreDataStack.mainContext)
        games = pool.flatMap { Game.fetchedGamesForPool($0).fetchedObjects }
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode {
        case .compact:
            preferredContentSize = maxSize
        case .expanded:
            let count = games?.count ?? 1
            let height = Double(count) * 93.5
            preferredContentSize = CGSize(width: 0.0, height: height)
        }
    }
    
//    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
//        // Perform any setup necessary in order to update the view.
//        
//        // If an error is encountered, use NCUpdateResult.Failed
//        // If there's no update required, use NCUpdateResult.NoData
//        // If there's an update, use NCUpdateResult.NewData
//        
//        completionHandler(NCUpdateResult.newData)
//    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in

        }, completion: nil)        
    }
}

// MARK: - Private

private extension TodayViewController {
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellClass: EventCell.self)
        tableView.register(cellClass: GameCell.self)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        view.addSubview(tableView)
        
        let emptyImage = UIImage(named: "icn-home")
        let emptyTitle = "No Events"
        let emptyMessage = "Nothing is happening this week"
        let emptyInfo = DefaultViewStateInfo(image: emptyImage, title: emptyTitle, message: emptyMessage)
        defaultView.setInfo(emptyInfo, state: .empty)
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let games = games {
            let game = games[indexPath.item]
            let gameViewModel = GameViewModel(game: game)
            let cell = tableView.dequeueCell(for: indexPath) as GameCell
            cell.configure(with: gameViewModel)
            cell.separatorHidden = indexPath.item == 0
            return cell
        }
        else {
            let cell = tableView.dequeueCell(for: indexPath) as EventCell
            cell.configure(with: event)
            cell.separatorHidden = indexPath.item == 0
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension TodayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
