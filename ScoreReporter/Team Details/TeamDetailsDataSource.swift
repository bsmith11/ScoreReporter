//
//  TeamDetailsDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/16/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import ScoreReporterCore

enum TeamDetailsInfo {
    case event(Event)
    case game(Game)
}

class TeamDetailsDataSource: NSObject, SectionedDataSource {
    typealias ModelType = TeamDetailsInfo
    
    fileprivate let gamesFetchedResultsController: NSFetchedResultsController<Game>

    fileprivate(set) var sections = [DataSourceSection<ModelType>]()

    let team: Team

    var refreshBlock: RefreshBlock?

    init(team: Team) {
        self.team = team

        gamesFetchedResultsController = Game.fetchedGamesFor(team: team)

        super.init()

        gamesFetchedResultsController.delegate = self

        configureSections()
    }

    deinit {
        gamesFetchedResultsController.delegate = nil
    }
}

// MARK: - Public

extension TeamDetailsDataSource {
    func refresh() {
        configureSections()
        refreshBlock?()
    }
}

// MARK: - Private

private extension TeamDetailsDataSource {
    func configureSections() {
        sections.removeAll()

        if let groups = team.groups as? Set<Group> {
            let events = groups.flatMap { $0.event }.sorted(by: { ($0.0.name ?? "") < ($0.1.name ?? "") })
            let eventItems = events.map { TeamDetailsInfo.event($0) }

            if !eventItems.isEmpty {
                sections.append(DataSourceSection(items: eventItems, headerTitle: "Events"))
            }
        }

//        if let games = gamesFetchedResultsController.fetchedObjects, !games.isEmpty {
//            sections.append(DataSourceSection(items: games.map { .game($0) }, headerTitle: "Active Games"))
//        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TeamDetailsDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        configureSections()
        refreshBlock?()
    }
}
