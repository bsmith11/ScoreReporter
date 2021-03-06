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

enum EventDetailsInfo {
    case division(Group)
    case activeGame(Game)

    var title: String {
        switch self {
        case .division(let group):
            let groupViewModel = GroupViewModel(group: group)
            return groupViewModel.fullName
        default:
            return ""
        }
    }
}

class EventDetailsDataSource: NSObject, SectionedDataSource {
    typealias ModelType = EventDetailsInfo
    
    fileprivate let activeGamesFetchedResultsController: NSFetchedResultsController<Game>

    fileprivate(set) var sections = [DataSourceSection<ModelType>]()

    let event: Event

    var refreshBlock: RefreshBlock?

    init(event: Event) {
        self.event = event

        activeGamesFetchedResultsController = Game.fetchedActiveGamesFor(event: event)

        super.init()

        configureSections()
    }
}

// MARK: - Private

private extension EventDetailsDataSource {
    func configureSections() {
        sections.removeAll()

        if let groups = (event.groups as? Set<Group>)?.sorted(by: { $0.0.groupID.intValue < $0.1.groupID.intValue }) {
            let divisions = groups.map { EventDetailsInfo.division($0) }
            sections.append(DataSourceSection(items: divisions, headerTitle: "Divisions"))
        }

        if let activeGames = activeGamesFetchedResultsController.fetchedObjects, !activeGames.isEmpty {
            sections.append(DataSourceSection(items: activeGames.map { .activeGame($0) }, headerTitle: "Active Games"))
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension EventDetailsDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        configureSections()
        refreshBlock?()
    }
}
