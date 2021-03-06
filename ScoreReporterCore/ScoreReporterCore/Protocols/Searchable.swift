//
//  Searchable.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public protocol Searchable {
    static var searchBarPlaceholder: String? { get }
    static var searchEmptyTitle: String? { get }
    static var searchEmptyMessage: String? { get }

    static func predicate(with searchText: String?) -> NSPredicate?

    var searchSectionTitle: String? { get }
    var searchLogoURL: URL? { get }
    var searchTitle: String? { get }
    var searchSubtitle: String? { get }
}
