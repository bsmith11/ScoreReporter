//
//  EventDetailsDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData
import ScoreReporterCore
import DataSource

enum EventDetailsInfo {
    case division(Group)
    case activeGame(Game)

    var title: String {
        switch self {
        case .division(let group):
            return group.fullName
        case .activeGame:
            return ""
        }
    }
}

class EventDetailsDataSource: NSObject, SectionedDataSource {
    typealias ModelType = EventDetailsInfo
    typealias SectionType = Section<EventDetailsInfo>
    
    fileprivate let activeGamesFRC: NSFetchedResultsController<ManagedGame>

    fileprivate(set) var sections = [Section<EventDetailsInfo>]()

    let event: Event
    
    var reloadBlock: ReloadBlock?

    init(event: Event) {
        self.event = event

        activeGamesFRC = ManagedGame.fetchedActiveGames(forEvent: event)
        
        super.init()
        
        activeGamesFRC.delegate = self

        configureSections()
    }
    
    deinit {
        activeGamesFRC.delegate = nil
    }
}

// MARK: - Private

private extension EventDetailsDataSource {
    func configureSections() {
        sections.removeAll()
        
        if !event.groups.isEmpty {
            let groupViewModels = event.groups.sorted(by: { $0.0.id < $0.1.id })
            let divisions = groupViewModels.map { EventDetailsInfo.division($0) }
            let section = Section(items: divisions, headerTitle: "Divisions")
            sections.append(section)
        }

        if let games = activeGamesFRC.fetchedObjects, !games.isEmpty {
            let items = games.flatMap { Game(game: $0) }.map { EventDetailsInfo.activeGame($0) }
            let section = Section(items: items, headerTitle: "Active Games")
            sections.append(section)
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension EventDetailsDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        configureSections()
        reloadBlock?([])
    }
}
