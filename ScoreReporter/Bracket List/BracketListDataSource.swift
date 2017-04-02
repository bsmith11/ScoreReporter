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

class BracketSection: Section<StageViewModel> {
    init(viewModel: BracketViewModel) {
        let headerTitle = viewModel.name
        let items = viewModel.stages.flatMap { StageViewModel(stage: $0) }.sorted(by: { $0.0.stageId < $0.1.stageId })
        
        super.init(items: items, headerTitle: headerTitle)
    }
}

class BracketListDataSource: NSObject, SectionedDataSource {
    typealias ModelType = StageViewModel
    typealias SectionType = BracketSection
    
    fileprivate(set) var fetchedResultsController: NSFetchedResultsController<Bracket>
    
    fileprivate(set) var sections = [BracketSection]()

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
        sections.removeAll()
        
        if let brackets = fetchedResultsController.fetchedObjects {
            let bracketSections = brackets.flatMap { BracketViewModel(bracket: $0) }.flatMap { BracketSection(viewModel: $0) }
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
