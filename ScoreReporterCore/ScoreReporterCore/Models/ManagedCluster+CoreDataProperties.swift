//
//  ManagedCluster+CoreDataProperties.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public extension ManagedCluster {

    @NSManaged var clusterID: NSNumber
    @NSManaged var name: String?
    @NSManaged var games: NSSet
    @NSManaged var round: ManagedRound?

}
