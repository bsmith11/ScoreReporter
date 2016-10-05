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
    let URL: NSURL?
    
    init?(dictionary: [String: AnyObject]) {
        guard let title = dictionary["Title"] as? String,
                  info = dictionary["FooterText"] as? String where !title.isEmpty else {
            return nil
        }
        
        self.title = title
        self.info = info
        URL = nil
    }
}

class AcknowledgementListDataSource: ArrayDataSource {
    typealias ModelType = Acknowledgement
    
    private(set) var items = [Acknowledgement]()
    
    init() {
        configureItems()
    }
}

// MARK: - Private

private extension AcknowledgementListDataSource {
    func configureItems() {
        guard let bundlePath = NSBundle.mainBundle().pathForResource("Settings", ofType: "bundle"),
            bundle = NSBundle(path: bundlePath),
            plistPath = bundle.pathForResource("Acknowledgements", ofType: "plist"),
            plist = NSDictionary(contentsOfFile: plistPath) as? [String: AnyObject],
            var pods = plist["PreferenceSpecifiers"] as? [[String: AnyObject]] else {
                return
        }
        
        pods.removeFirst()
        
        items = pods.flatMap({Acknowledgement(dictionary: $0)})
    }
}
