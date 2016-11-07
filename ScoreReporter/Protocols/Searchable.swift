//
//  Searchable.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

protocol Searchable {
    static var searchFetchedResultsController: NSFetchedResultsController { get }
    static var searchBarPlaceholder: String? { get }
    static var searchEmptyTitle: String? { get }
    static var searchEmptyMessage: String? { get }
    
    static func predicateWithSearchText(searchText: String?) -> NSPredicate?
    
    var searchSectionTitle: String? { get }
    var searchLogoURL: NSURL? { get }
    var searchTitle: String? { get }
    var searchSubtitle: String? { get }
}
