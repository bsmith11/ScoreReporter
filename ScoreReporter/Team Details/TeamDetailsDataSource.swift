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
import DataSource

enum TeamDetailsInfo {
    case event(ManagedEvent)
    case game(ManagedGame)
}

class TeamDetailsDataSource: NSObject, SectionedDataSource {
    typealias ModelType = TeamDetailsInfo
    typealias SectionType = Section<ModelType>
    
    fileprivate let gamesFetchedResultsController: NSFetchedResultsController<ManagedGame>

    fileprivate(set) var sections = [Section<ModelType>]()

    let team: ManagedTeam

    var reloadBlock: ReloadBlock?

    init(team: ManagedTeam) {
        self.team = team

        gamesFetchedResultsController = ManagedGame.fetchedGamesFor(team: team)

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
        reloadBlock?([])
    }
}

// MARK: - Private

private extension TeamDetailsDataSource {
    func configureSections() {
        sections.removeAll()

        if let groups = team.groups as? Set<ManagedGroup> {
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
        reloadBlock?([])
    }
}
