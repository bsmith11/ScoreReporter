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

    @discardableResult
    static func object(from dictionary: [String: Any]) -> ImportType?
}

public extension Importable {
    @discardableResult
    static func objects(from array: [[String: Any]]) -> [ImportType] {
        return array.flatMap { object(from: $0) }
    }
}

public protocol CoreDataImportable {
    associatedtype CoreDataImportType: NSManagedObject = Self

    @discardableResult
    static func object(from dictionary: [String: Any], context: NSManagedObjectContext) -> CoreDataImportType?
}

public extension CoreDataImportable where Self: NSManagedObject {
    @discardableResult
    static func objects(from array: [[String: Any]], context: NSManagedObjectContext) -> [CoreDataImportType] {
        return array.flatMap { object(from: $0, context: context) }
    }
}
