//
//  ManagedBracket+CoreDataProperties.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public extension ManagedBracket {

    @NSManaged var bracketID: NSNumber
    @NSManaged var name: String?
    @NSManaged var sortOrder: NSNumber?
    @NSManaged var round: ManagedRound?
    @NSManaged var stages: NSSet

}
