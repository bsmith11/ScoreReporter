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

//struct BracketSection {
//    let bracket: Bracket
//    let title: String
//    let stages: [Stage]
//    
//    init(bracket: Bracket) {
//        self.bracket = bracket
//        
//        title = bracket.name ?? "Bracket"
//        stages = bracket.stages.allObjects as? [Stage] ?? []
//    }
//}

class BracketListDataSource: NSObject, SectionedDataSource {
    typealias ModelType = Stage
    typealias SectionType = Section<Stage>
    
    fileprivate(set) var fetchedResultsController: NSFetchedResultsController<Bracket>
    
    fileprivate(set) var sections = [Section<Stage>]()

    fileprivate(set) dynamic var empty = false
    
    var reloadBlock: ReloadBlock?
    
    init(viewModel: GroupViewModel) {
        fetchedResultsController = Bracket.fetchedBracketsForGroup(withId: viewModel.groupID)

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
        let brackets = fetchedResultsController.fetchedObjects ?? []
        let stages = brackets.flatMap { $0.stages.allObjects as? [Stage] }
        sections = stages.map { Section(items: $0, headerTitle: $0.first?.bracket?.name) }
        
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
