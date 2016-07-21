//
//  CoreDataStack.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import RZVinyl

class CoreDataStack: RZCoreDataStack {
    static func configureStack() {
        let options: RZCoreDataStackOptions = [
            .DeleteDatabaseIfUnreadable,
            .EnableAutoStalePurge
        ]
        let stack = RZCoreDataStack(modelName: "ScoreReporter", configuration: nil, storeType: NSSQLiteStoreType, storeURL: nil, options: options)

        assert(stack != nil, "Failed to create Core Data stack")
        RZCoreDataStack.setDefaultStack(stack ?? RZCoreDataStack())
    }
}