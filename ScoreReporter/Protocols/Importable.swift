//
//  Importable.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 10/29/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public protocol Importable {
    associatedtype ImportType = Self
    
    static func objectFromDictionary(_ dictionary: [String: AnyObject]) -> ImportType?
}

public extension Importable {
    static func objectsFromArray(_ array: [[String: AnyObject]]) -> [ImportType] {
        return array.flatMap({objectFromDictionary($0)})
    }
}

public protocol CoreDataImportable {
    associatedtype CoreDataImportType: NSManagedObject = Self
    
    static func objectFromDictionary(_ dictionary: [String: AnyObject], context: NSManagedObjectContext) -> CoreDataImportType?
}

public extension CoreDataImportable where Self: NSManagedObject {
    @discardableResult
    static func objectsFromArray(_ array: [[String: AnyObject]], context: NSManagedObjectContext) -> [CoreDataImportType] {
        return array.flatMap({objectFromDictionary($0, context: context)})
    }
}
