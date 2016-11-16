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
import CoreData

public protocol SearchViewControllerDelegate: class {
    func didSelect(item: Searchable)
}

public class SearchViewController<Model: NSManagedObject where Model: Searchable>: UIViewController {
    fileprivate let dataSource: SearchDataSource<Model>
    fileprivate let searchBar = UISearchBar(frame: .zero)
    fileprivate let tableView = UITableView(frame: .zero, style: .plain)
    fileprivate let defaultView = DefaultView(frame: .zero)
    
    fileprivate var tableViewProxy: TableViewProxy?
    fileprivate var searchBarProxy: SearchBarProxy?
    fileprivate var selectedCell: UITableViewCell?
    
    public weak var delegate: SearchViewControllerDelegate?
    
    public init(dataSource: SearchDataSource<Model>) {
        self.dataSource = dataSource
        
        super.init(nibName: nil, bundle: nil)
        
        tableViewProxy = TableViewProxy(dataSource: self, delegate: self)
        searchBarProxy = SearchBarProxy(delegate: self)
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    public override func loadView() {
        view = UIView()
        
        configureViews()
        configureLayout()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureObservers()
        
        dataSource.refreshBlock = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        transitionCoordinator?.animate(alongsideTransition: nil) { [weak self] _ in
            self?.searchBar.becomeFirstResponder()
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchBar.resignFirstResponder()
        
        transitionCoordinator?.animate(alongsideTransition: nil, completion: { [weak self] _ in
            self?.selectedCell?.isHidden = false
        })
    }
}

// MARK: - Private

private extension SearchViewController {
    func configureViews() {
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.spellCheckingType = .no
        searchBar.placeholder = Model.searchBarPlaceholder
        searchBar.tintColor = UIColor.scBlue
        searchBar.delegate = searchBarProxy
        navigationItem.titleView = searchBar
        
        tableView.dataSource = tableViewProxy
        tableView.delegate = tableViewProxy
        tableView.register(headerFooterClass: SectionHeaderView.self)
        tableView.register(cellClass: SearchCell.self)
        tableView.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
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

// MARK: - TableViewProxyDataSource

extension SearchViewController: TableViewProxyDataSource {
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let searchable = dataSource.item(at: indexPath)
        let cell = tableView.dequeueCell(for: indexPath) as SearchCell
        cell.configure(with: searchable)
        cell.separatorHidden = indexPath.item == 0
        
        return cell
    }
}

// MARK: - TableViewProxyDelegate

extension SearchViewController: TableViewProxyDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        guard let title = dataSource.title(for: section) else {
            return 0.0
        }
        
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = dataSource.title(for: section) else {
            return nil
        }
        
        let headerView = tableView.dequeueHeaderFooterView() as SectionHeaderView
        headerView.configure(with: title)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        guard let searchable = dataSource.item(at: indexPath) else {
            return
        }
        
        selectedCell = tableView.cellForRow(at: indexPath)
        
        delegate?.didSelect(item: searchable)
    }
}

// MARK: - SearchBarProxyDelegate

extension SearchViewController: SearchBarProxyDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        dataSource.search(for: nil)
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataSource.search(for: searchText)
    }
}

// MARK: - ListDetailAnimationControllerDelegate

extension SearchViewController: ListDetailAnimationControllerDelegate {
    public var viewToAnimate: UIView {
        guard let cell = selectedCell as? SearchCell,
            let navView = navigationController?.view,
            let snapshot = cell.snapshot(rect: cell.contentFrame) else {
                return UIView()
        }
        
        let frame = cell.contentFrameFrom(view: navView)
        snapshot.frame = frame
        
        cell.isHidden = true
        
        return snapshot
    }
}
