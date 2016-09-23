//
//  Cluster+CoreDataProperties.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Cluster {

    @NSManaged var clusterID: NSNumber
    @NSManaged var name: String?
    @NSManaged var games: NSSet
    @NSManaged var round: Round?

}
