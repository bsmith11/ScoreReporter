//
//  TeamsDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/22/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData
import ScoreReporterCore
import DataSource

class TeamsDataSource: NSObject, FetchedDataSource, FetchedChangable {
    typealias ModelType = Team

    fileprivate(set) var fetchedResultsController = Team.fetchedBookmarkedTeams()

    dynamic var empty = false

    var fetchedChangeHandler: FetchedChangeHandler?
    var reloadBlock: ReloadBlock?

    override init() {
        super.init()

        register(fetchedResultsController: fetchedResultsController)

        empty = fetchedResultsController.fetchedObjects?.isEmpty ?? true
    }

    deinit {
        unregister(fetchedResultsController: fetchedResultsController)
    }
}

// MARK: - Public

extension TeamsDataSource {
    func title(for section: Int) -> String? {
        guard !(fetchedResultsController.fetchedObjects?.isEmpty ?? true) else {
            return nil
        }

        return "My Teams"
    }
}
