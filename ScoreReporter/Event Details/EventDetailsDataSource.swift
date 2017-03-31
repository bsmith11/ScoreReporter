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
    case division(GroupViewModel)
    case activeGame(GameViewModel)

    var title: String {
        switch self {
        case .division(let viewModel):
            return viewModel.fullName
        case .activeGame:
            return ""
        }
    }
}

class EventDetailsDataSource: NSObject, SectionedDataSource {
    typealias ModelType = EventDetailsInfo
    typealias SectionType = Section<EventDetailsInfo>
    
    fileprivate let activeGamesFRC: NSFetchedResultsController<Game>

    fileprivate(set) var sections = [Section<EventDetailsInfo>]()

    let viewModel: EventViewModel
    
    var reloadBlock: ReloadBlock?

    init(viewModel: EventViewModel) {
        self.viewModel = viewModel

        activeGamesFRC = Game.fetchedActiveGames(forEventID: viewModel.eventID)
        
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
        
        if !viewModel.groups.isEmpty {
            let groupViewModels = viewModel.groups.sorted(by: { $0.0.groupID < $0.1.groupID })
            let divisions = groupViewModels.map { EventDetailsInfo.division($0) }
            let section = Section(items: divisions, headerTitle: "Divisions")
            sections.append(section)
        }

        if let games = activeGamesFRC.fetchedObjects, !games.isEmpty {
            let items = games.map { GameViewModel(game: $0) }.map { EventDetailsInfo.activeGame($0) }
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
