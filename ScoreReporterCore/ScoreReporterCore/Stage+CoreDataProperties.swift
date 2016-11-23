//
//  Stage+CoreDataProperties.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public extension Stage {

    @NSManaged var name: String?
    @NSManaged var stageID: NSNumber
    @NSManaged var bracket: Bracket?
    @NSManaged var games: NSSet

}
