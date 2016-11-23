//
//  Round+CoreDataProperties.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public extension Round {

    @NSManaged var roundID: NSNumber
    @NSManaged var brackets: NSSet
    @NSManaged var clusters: NSSet
    @NSManaged var group: Group?
    @NSManaged var pools: NSSet

}
