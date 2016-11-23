//
//  Pool+CoreDataProperties.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public extension Pool {

    @NSManaged var name: String?
    @NSManaged var poolID: NSNumber
    @NSManaged var games: NSSet
    @NSManaged var round: Round?
    @NSManaged var standings: NSSet

}
