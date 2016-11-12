//
//  SearchViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import KVOController

protocol SearchViewControllerDelegate: class {
    func didSelectItem(_ item: Searchable)
}

class SearchViewController<Model: Searchable>: UIViewController {
    fileprivate let dataSource: SearchDataSource<Model>
    fileprivate let searchBar = UISearchBar(frame: .zero)
    fileprivate let tableView = UITableView(frame: .zero, style: .plain)
    fileprivate let defaultView = DefaultView(frame: .zero)
    
    fileprivate var searchTableViewHelper: SearchTableViewHelper?
    fileprivate var searchBarHelper: SearchBarHelper?
    
    weak var delegate: SearchViewControllerDelegate?
    
    init() {
        dataSource = SearchDataSource<Model>()
        
        super.init(nibName: nil, bundle: nil)
        
        searchTableViewHelper = SearchTableViewHelper(dataSource: self, delegate: self)
        searchBarHelper = SearchBarHelper(delegate: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        view = UIView()
        
        configureViews()
        configureLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureObservers()
        
        dataSource.refreshBlock = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        deselectRowsInTableView(tableView, animated: animated)
        
        transitionCoordinator?.animate(alongsideTransition: nil) { [weak self] _ in
            self?.searchBar.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchBar.resignFirstResponder()
    }
}

// MARK: - Private

private extension SearchViewController {
    func configureViews() {
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.spellCheckingType = .no
        searchBar.placeholder = Model.searchBarPlaceholder
        searchBar.tintColor = UIColor.USAUNavyColor()
        searchBar.delegate = searchBarHelper
        
        var frame = navigationController?.navigationBar.frame ?? .zero
        frame.size.width = frame.width - (8.0 + 8.0 + 13.0 + 16.0)
        frame.origin.x = CGFloat(8.0 + 13.0 + 16.0)
        searchBar.frame = frame
        
        navigationItem.titleView = searchBar
        
        tableView.dataSource = searchTableViewHelper
        tableView.delegate = searchTableViewHelper
        tableView.registerClass(SearchCell.self)
        tableView.registerHeaderFooterClass(SectionHeaderView.self)
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 44.0
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        tableView.alwaysBounceVertical = true
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        let emptyImage = UIImage(named: "icn-search")
        let emptyTitle = Model.searchEmptyTitle
        let emptyMessage = Model.searchEmptyMessage
        let emptyInfo = DefaultViewStateInfo(image: emptyImage, title: emptyTitle, message: emptyMessage)
        defaultView.setInfo(emptyInfo, state: .empty)
        view.addSubview(defaultView)
    }
    
    func configureLayout() {
        tableView.topAnchor == topLayoutGuide.bottomAnchor
        tableView.horizontalAnchors == horizontalAnchors
        tableView.keyboardLayoutGuide.bottomAnchor == bottomLayoutGuide.topAnchor
        
        defaultView.edgeAnchors == tableView.edgeAnchors
    }
    
    func configureObservers() {
        kvoController.observe(dataSource, keyPath: "empty") { [weak self] (empty: Bool) in
            self?.defaultView.empty = empty
        }
    }
}

// MARK: - SearchTableViewDataSource

extension SearchViewController: SearchTableViewDataSource {
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCellForIndexPath(indexPath) as SearchCell
        let item = dataSource.item(at: indexPath)
        
        cell.configure(with: item)
        
        return cell
    }
}

// MARK: - SearchTableViewDelegate

extension SearchViewController: SearchTableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        guard let _ = dataSource.titleForSection(section) else {
            return 0.0
        }
        
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueHeaderFooterView() as SectionHeaderView
        let title = dataSource.titleForSection(section)
        
        headerView.configure(with: title)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        guard let item = dataSource.item(at: indexPath) else {
            return
        }
        
        delegate?.didSelectItem(item)
    }
}

// MARK: - SearchBarHelperDelegate

extension SearchViewController: SearchBarHelperDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        dataSource.searchWithText(nil)
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataSource.searchWithText(searchText)
    }
}

// MARK: - SearchBarHelper

private protocol SearchBarHelperDelegate: class {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
}

private class SearchBarHelper: NSObject {
    fileprivate unowned let delegate: SearchBarHelperDelegate
    
    init(delegate: SearchBarHelperDelegate) {
        self.delegate = delegate
    }
}

extension SearchBarHelper: UISearchBarDelegate {
    @objc func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegate.searchBarCancelButtonClicked(searchBar)
    }
    
    @objc func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate.searchBar(searchBar, textDidChange: searchText)
    }
}

// MARK: - SearchTableViewHelper

private protocol SearchTableViewDataSource: class {
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
}

private protocol SearchTableViewDelegate: class {
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
}

private class SearchTableViewHelper: NSObject {
    fileprivate unowned let dataSource: SearchTableViewDataSource
    fileprivate unowned let delegate: SearchTableViewDelegate
    
    init(dataSource: SearchTableViewDataSource, delegate: SearchTableViewDelegate) {
        self.dataSource = dataSource
        self.delegate = delegate
    }
}

extension SearchTableViewHelper: UITableViewDataSource {
    @objc func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSectionsInTableView(tableView)
    }
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.tableView(tableView, numberOfRowsInSection: section)
    }
    
    @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSource.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
}

extension SearchTableViewHelper: UITableViewDelegate {
    @objc func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return delegate.tableView(tableView, estimatedHeightForHeaderInSection: section)
    }
    
    @objc func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return delegate.tableView(tableView, viewForHeaderInSection: section)
    }
    
    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.tableView(tableView, didSelectRowAtIndexPath: indexPath)
    }
}
