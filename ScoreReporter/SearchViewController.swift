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
    func didSelectItem(item: Searchable)
}

class SearchViewController<Model: Searchable>: UIViewController {
    private let dataSource: SearchDataSource<Model>
    private let searchBar = UISearchBar(frame: .zero)
    private let tableView = UITableView(frame: .zero, style: .Plain)
    private let defaultView = DefaultView(frame: .zero)
    
    private var searchTableViewHelper: SearchTableViewHelper?
    private var searchBarHelper: SearchBarHelper?
    
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
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        deselectRowsInTableView(tableView, animated: animated)
        
        transitionCoordinator()?.animateAlongsideTransition(nil) { [weak self] _ in
            self?.searchBar.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchBar.resignFirstResponder()
    }
}

// MARK: - Private

private extension SearchViewController {
    func configureViews() {
        searchBar.autocapitalizationType = .None
        searchBar.autocorrectionType = .No
        searchBar.spellCheckingType = .No
        searchBar.placeholder = Model.searchBarPlaceholder
        searchBar.tintColor = UIColor.USAUNavyColor()
        searchBar.delegate = searchBarHelper
        
        var frame = navigationController?.navigationBar.frame ?? .zero
        frame.size.width = frame.width - (8.0 + 8.0 + 13.0 + 16.0)
        frame.origin.x = 8.0 + 13.0 + 16.0
        searchBar.frame = frame
        
        navigationItem.titleView = searchBar
        
        tableView.dataSource = searchTableViewHelper
        tableView.delegate = searchTableViewHelper
        tableView.registerClass(SearchCell)
        tableView.registerHeaderFooterClass(SectionHeaderView)
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 44.0
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.alwaysBounceVertical = true
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        let emptyImage = UIImage(named: "icn-search")
        let emptyTitle = Model.searchEmptyTitle
        let emptyMessage = Model.searchEmptyMessage
        let emptyInfo = DefaultViewStateInfo(image: emptyImage, title: emptyTitle, message: emptyMessage)
        defaultView.setInfo(emptyInfo, state: .Empty)
        view.addSubview(defaultView)
    }
    
    func configureLayout() {
        tableView.topAnchor == topLayoutGuide.bottomAnchor
        tableView.horizontalAnchors == horizontalAnchors
        tableView.keyboardLayoutGuide.bottomAnchor == bottomLayoutGuide.topAnchor
        
        defaultView.edgeAnchors == tableView.edgeAnchors
    }
    
    func configureObservers() {
        KVOController.observe(dataSource, keyPath: "empty") { [weak self] (empty: Bool) in
            self?.defaultView.empty = empty
        }
    }
}

// MARK: - SearchTableViewDataSource

extension SearchViewController: SearchTableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItemsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCellForIndexPath(indexPath) as SearchCell
        let item = dataSource.itemAtIndexPath(indexPath)
        
        cell.configureWithSearchable(item)
        
        return cell
    }
}

// MARK: - SearchTableViewDelegate

extension SearchViewController: SearchTableViewDelegate {
    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        guard let _ = dataSource.titleForSection(section) else {
            return 0.0
        }
        
        return 44.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueHeaderFooterView() as SectionHeaderView
        let title = dataSource.titleForSection(section)
        
        headerView.configureWithTitle(title)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let item = dataSource.itemAtIndexPath(indexPath) else {
            return
        }
        
        delegate?.didSelectItem(item)
    }
}

// MARK: - SearchBarHelperDelegate

extension SearchViewController: SearchBarHelperDelegate {
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = nil
        dataSource.searchWithText(nil)
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        dataSource.searchWithText(searchText)
    }
}

// MARK: - SearchBarHelper

private protocol SearchBarHelperDelegate: class {
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
}

private class SearchBarHelper: NSObject {
    private unowned let delegate: SearchBarHelperDelegate
    
    init(delegate: SearchBarHelperDelegate) {
        self.delegate = delegate
    }
}

extension SearchBarHelper: UISearchBarDelegate {
    @objc func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        delegate.searchBarCancelButtonClicked(searchBar)
    }
    
    @objc func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        delegate.searchBar(searchBar, textDidChange: searchText)
    }
}

// MARK: - SearchTableViewHelper

private protocol SearchTableViewDataSource: class {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
}

private protocol SearchTableViewDelegate: class {
    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
}

private class SearchTableViewHelper: NSObject {
    private unowned let dataSource: SearchTableViewDataSource
    private unowned let delegate: SearchTableViewDelegate
    
    init(dataSource: SearchTableViewDataSource, delegate: SearchTableViewDelegate) {
        self.dataSource = dataSource
        self.delegate = delegate
    }
}

extension SearchTableViewHelper: UITableViewDataSource {
    @objc func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.numberOfSectionsInTableView(tableView)
    }
    
    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.tableView(tableView, numberOfRowsInSection: section)
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return dataSource.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
}

extension SearchTableViewHelper: UITableViewDelegate {
    @objc func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return delegate.tableView(tableView, estimatedHeightForHeaderInSection: section)
    }
    
    @objc func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return delegate.tableView(tableView, viewForHeaderInSection: section)
    }
    
    @objc func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate.tableView(tableView, didSelectRowAtIndexPath: indexPath)
    }
}
