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
    case event(Event)
    case game(Game)
}

class TeamDetailsDataSource: NSObject, SectionedDataSource {
    typealias ModelType = TeamDetailsInfo
    typealias SectionType = Section<TeamDetailsInfo>
    
    fileprivate let gamesFetchedResultsController: NSFetchedResultsController<ManagedGame>

    fileprivate(set) var sections = [Section<TeamDetailsInfo>]()

    let team: Team

    var reloadBlock: ReloadBlock?

    init(team: Team) {
        self.team = team

        gamesFetchedResultsController = ManagedGame.fetchedGames(forTeam: team)

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

//        //TODO - Fix
//        if let groups = team.groups as? Set<ManagedGroup> {
//            let events = groups.flatMap { $0.event }.sorted(by: { $0.0.name < $0.1.name })
//            let eventItems = events.map { TeamDetailsInfo.event($0) }
//
//            if !eventItems.isEmpty {
//                sections.append(Section(items: eventItems, headerTitle: "Events"))
//            }
//        }

        if let managedGames = gamesFetchedResultsController.fetchedObjects, !managedGames.isEmpty {
            let items = managedGames.flatMap { Game(game: $0) }.map { TeamDetailsInfo.game($0) }
            let gameSection = Section(items: items, headerTitle: "Active Games")
            sections.append(gameSection)
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
