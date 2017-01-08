//
//  SearchBarProxy.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/14/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import UIKit

protocol SearchBarProxyDelegate: class {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    func searchBarTextWillBeginEditing(_ searchBar: UISearchBar)
}

class SearchBarProxy: NSObject {
    fileprivate unowned let delegate: SearchBarProxyDelegate

    init(delegate: SearchBarProxyDelegate) {
        self.delegate = delegate
    }
}

extension SearchBarProxy: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegate.searchBarCancelButtonClicked(searchBar)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate.searchBar(searchBar, textDidChange: searchText)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        delegate.searchBarTextWillBeginEditing(searchBar)
        
        return true
    }
}
