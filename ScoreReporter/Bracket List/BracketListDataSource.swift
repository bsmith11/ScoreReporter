//
//  BracketListDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/26/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData
import ScoreReporterCore
import DataSource

class BracketSection: Section<Stage> {
    init(bracket: Bracket) {
        let headerTitle = bracket.name
        let items = bracket.stages.sorted(by: { $0.0.id < $0.1.id })
        
        super.init(items: items, headerTitle: headerTitle)
    }
}

class BracketListDataSource: NSObject, SectionedDataSource {
    typealias ModelType = Stage
    typealias SectionType = BracketSection
    
    fileprivate(set) var fetchedResultsController: NSFetchedResultsController<ManagedBracket>
    
    fileprivate(set) var sections = [BracketSection]()

    fileprivate(set) dynamic var empty = false
    
    var reloadBlock: ReloadBlock?
    
    init(group: Group) {
        fetchedResultsController = ManagedBracket.fetchedBrackets(forGroup: group)

        super.init()

        fetchedResultsController.delegate = self
        
        configureSections()
    }

    deinit {
        fetchedResultsController.delegate = nil
    }
}

// MARK: - Private

private extension BracketListDataSource {
    func configureSections() {
        sections.removeAll()
        
        if let managedBrackets = fetchedResultsController.fetchedObjects {
            let bracketSections = managedBrackets.flatMap { Bracket(bracket: $0) }.map { BracketSection(bracket: $0) }
            sections.append(contentsOf: bracketSections)
        }
        
        empty = sections.isEmpty
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension BracketListDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        configureSections()
        reloadBlock?([])
    }
}
