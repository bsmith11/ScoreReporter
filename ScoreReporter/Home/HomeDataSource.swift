//
//  HomeDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/17/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData
import ScoreReporterCore
import DataSource

class HomeDataSource: NSObject, SectionedDataSource {
    typealias ModelType = Event
    typealias SectionType = Section<Event>

    fileprivate let fetchedResultsController = ManagedEvent.fetchedEventsThisWeek()

    fileprivate(set) var sections = [Section<Event>]()
    
    fileprivate(set) dynamic var empty = false

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

private extension HomeDataSource {
    func configureSections() {
        sections.removeAll()
        
        if let fetchedObjects = fetchedResultsController.fetchedObjects, !fetchedObjects.isEmpty {
            let events = fetchedObjects.map { Event(event: $0) }
            let section = Section(items: events, headerTitle: "This Week")
            sections.append(section)
        }
        
        empty = sections.isEmpty
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension HomeDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        configureSections()
        reloadBlock?([])
    }
}
