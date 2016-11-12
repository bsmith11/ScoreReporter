//
//  AcknowledgementListDataSource.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 10/4/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

struct Acknowledgement {
    let title: String
    let info: String
    let URL: URL?
    
    init?(dictionary: [String: AnyObject]) {
        guard let title = dictionary["Title"] as? String,
              let info = dictionary["FooterText"] as? String,
              !title.isEmpty else {
            return nil
        }
        
        self.title = title
        self.info = info
        URL = nil
    }
}

class AcknowledgementListDataSource: ArrayDataSource {
    typealias ModelType = Acknowledgement
    
    fileprivate(set) var items = [Acknowledgement]()
    
    init() {
        configureItems()
    }
}

// MARK: - Private

private extension AcknowledgementListDataSource {
    func configureItems() {
        guard let bundlePath = Bundle.main.path(forResource: "Settings", ofType: "bundle"),
              let bundle = Bundle(path: bundlePath),
              let plistPath = bundle.path(forResource: "Acknowledgements", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: plistPath) as? [String: AnyObject],
              var pods = plist["PreferenceSpecifiers"] as? [[String: AnyObject]] else {
            return
        }
        
        pods.removeFirst()
        
        items = pods.flatMap({Acknowledgement(dictionary: $0)})
    }
}
