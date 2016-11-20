//
//  TodayDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData
import ScoreReporterCore

struct TodaySection {
    let team: Team
    let event: Event
    let games: [Game]
}

class TodayDataSource: NSObject {
    fileprivate var sections = [TodaySection]()
    
    dynamic var empty = false
    
    var teams = [Team]() {
        didSet {
            configureSections()
        }
    }
    
    override init() {
        super.init()
        
        configureSections()
    }
}

// MARK: - Public

extension TodayDataSource {
    func section(for section: Int) -> TodaySection? {
        guard section < sections.count else {
            return nil
        }
        
        return sections[section]
    }
}

// MARK: - Private

private extension TodayDataSource {
    func configureSections() {
        
    }
}

// MARK: - DataSource

extension TodayDataSource: DataSource {
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        guard section < sections.count else {
            return 0
        }
        
        return sections[section].games.count
    }
    
    func item(at indexPath: IndexPath) -> Game? {
        guard indexPath.section < sections.count else {
            return nil
        }
        
        let section = sections[indexPath.section]
        
        guard indexPath.item < section.games.count else {
            return nil
        }
        
        return section.games[indexPath.item]
    }
}
