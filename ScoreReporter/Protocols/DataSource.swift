//
//  DataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/21/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import CoreData

protocol DataSource {
    associatedtype ModalType

    func numberOfSections() -> Int
    func numberOfItemsInSection(section: Int) -> Int
    func itemAtIndexPath(indexPath: NSIndexPath) -> ModalType?
}

protocol FetchedDataSource: DataSource {
    var fetchedResultsController: NSFetchedResultsController { get set }
}

extension FetchedDataSource {
    func numberOfSections() -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    func numberOfItemsInSection(section: Int) -> Int {
        guard let sections = fetchedResultsController.sections where section < sections.count else {
            return 0
        }

        return sections[section].numberOfObjects
    }

    func itemAtIndexPath(indexPath: NSIndexPath) -> ModalType? {
        return fetchedResultsController.objectAtIndexPath(indexPath) as? ModalType
    }
}
