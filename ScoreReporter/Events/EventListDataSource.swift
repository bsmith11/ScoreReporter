//
//  EventListDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/22/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData
import ScoreReporterCore
import EZDataSource

class EventListDataSource: NSObject, SectionedDataSource {
    typealias ItemType = EventViewModel
    typealias SectionType = Section<EventViewModel>

    fileprivate let fetchedResultsController = Event.fetchedBookmarkedEvents()

    fileprivate(set) var sections = [Section<EventViewModel>]()
    
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

private extension EventListDataSource {
    func configureSections() {
        sections.removeAll()
        
        if let fetchedObjects = fetchedResultsController.fetchedObjects, !fetchedObjects.isEmpty {
            let viewModels = fetchedObjects.map { EventViewModel(event: $0) }
            let section = Section(items: viewModels, headerTitle: "My Events")
            sections.append(section)
        }
        
        empty = sections.isEmpty
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension EventListDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        configureSections()
        reloadBlock?(.all)
    }
}
