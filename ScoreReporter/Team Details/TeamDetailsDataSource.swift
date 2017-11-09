//
//  TeamDetailsDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/16/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import CoreData
import ScoreReporterCore
import EZDataSource

enum TeamDetailsInfo {
    case event(Event)
    case game(Game)
}

class TeamDetailsDataSource: NSObject, SectionedDataSource {
    typealias ItemType = TeamDetailsInfo
    typealias SectionType = Section<ItemType>
    
    fileprivate let gamesFetchedResultsController: NSFetchedResultsController<Game>

    fileprivate(set) var sections = [Section<ItemType>]()

    let team: Team

    var reloadBlock: ReloadBlock?

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
        reloadBlock?(.all)
    }
}

// MARK: - Private

private extension TeamDetailsDataSource {
    func configureSections() {
        sections.removeAll()

        if let groups = team.groups as? Set<Group> {
            let events = groups.flatMap { $0.event }.sorted(by: { $0.0.name < $0.1.name })
            let eventItems = events.map { TeamDetailsInfo.event($0) }

            if !eventItems.isEmpty {
                sections.append(Section(items: eventItems, headerTitle: "Events"))
            }
        }

        if let games = gamesFetchedResultsController.fetchedObjects, !games.isEmpty {
            sections.append(Section(items: games.map { .game($0) }, headerTitle: "Active Games"))
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TeamDetailsDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        configureSections()
        reloadBlock?(.all)
    }
}
