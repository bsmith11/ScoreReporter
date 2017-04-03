//
//  TeamListDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/22/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData
import ScoreReporterCore
import DataSource

class TeamListDataSource: NSObject, SectionedDataSource {
    typealias ModelType = Team
    typealias SectionType = Section<Team>

    fileprivate(set) var sections = [Section<Team>]()
    fileprivate(set) var fetchedResultsController = ManagedTeam.fetchedBookmarkedTeams()

    dynamic var empty = false

    var reloadBlock: ReloadBlock?

    override init() {
        super.init()

        fetchedResultsController.delegate = self

        configureSections()
    }

    deinit {
        fetchedResultsController.delegate = nil
    }
}

// MARK: - Private

private extension TeamListDataSource {
    func configureSections() {
        sections.removeAll()
        
        if let fetchedObjects = fetchedResultsController.fetchedObjects, !fetchedObjects.isEmpty {
            let teams = fetchedObjects.map { Team(team: $0) }.sorted(by: { $0.0.id < $0.1.id })
            let section = Section(items: teams, headerTitle: "My Teams")
            sections.append(section)
        }
        
        empty = sections.isEmpty
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TeamListDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        configureSections()
        reloadBlock?([])
    }
}
