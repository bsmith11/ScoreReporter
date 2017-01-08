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

public typealias SearchAnimationCompletion = () -> Void

public protocol SearchViewControllerDelegate: class {
    func didSelect(item: Searchable)
    func didSelectCancel()
    func willBeginEditing()
}

public class SearchViewController<Model: NSManagedObject where Model: Searchable>: UIViewController, KeyboardObservable {
    fileprivate let dataSource: SearchDataSource<Model>
    fileprivate let visualEffectView = UIVisualEffectView(effect: nil)
    fileprivate let tableView = UITableView(frame: .zero, style: .grouped)
    fileprivate let defaultView = DefaultView(frame: .zero)

    fileprivate var tableViewProxy: TableViewProxy?
    fileprivate var searchBarProxy: SearchBarProxy?

    public let searchBar = UISearchBar(frame: .zero)

    public weak var delegate: SearchViewControllerDelegate?

    public init(dataSource: SearchDataSource<Model>) {
        self.dataSource = dataSource

        super.init(nibName: nil, bundle: nil)

        tableViewProxy = TableViewProxy(dataSource: self, delegate: self)
        searchBarProxy = SearchBarProxy(delegate: self)

        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.spellCheckingType = .no
        searchBar.placeholder = Model.searchBarPlaceholder
        searchBar.tintColor = UIColor.scBlue
        searchBar.delegate = searchBarProxy

        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    public override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.clear
        
        configureViews()
        configureLayout()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        configureObservers()

        addKeyboardObserver { [weak self] (_, keyboardFrame) in
            guard let sself = self else {
                return
            }

            let frameInWindow = sself.view.convert(sself.tableView.frame, to: nil)
            let bottomInset = max(0.0, frameInWindow.maxY - keyboardFrame.minY)
            
            self?.tableView.contentInset.bottom = bottomInset
            self?.tableView.scrollIndicatorInsets.bottom = bottomInset
        }
        
        dataSource.refreshBlock = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        transitionCoordinator?.animate(alongsideTransition: nil) { [weak self] _ in
            self?.searchBar.becomeFirstResponder()
        }
        
        deselectRows(in: tableView, animated: animated)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        searchBar.resignFirstResponder()
    }
}

// MARK: - Public

public extension SearchViewController {
    func beginAppearanceAnimation(completion: SearchAnimationCompletion?) {
        tableView.alpha = 0.0
        tableView.transform = CGAffineTransform(translationX: 0.0, y: 44.0)
        
        let animations = {
            self.visualEffectView.effect = UIBlurEffect(style: .light)
            self.tableView.alpha = 1.0
            self.tableView.transform = CGAffineTransform.identity
        }
        
        UIView.animate(withDuration: 0.25, animations: animations) { finished in
            completion?()
        }
    }
    
    func beginDisappearanceAnimation(completion: SearchAnimationCompletion?) {
        let animations = {
            self.visualEffectView.effect = nil
            self.tableView.alpha = 0.0
            self.tableView.transform = CGAffineTransform(translationX: 0.0, y: 44.0)
        }
        
        UIView.animate(withDuration: 0.25, animations: animations) { finished in
            self.tableView.alpha = 1.0
            self.tableView.transform = CGAffineTransform.identity
            
            completion?()
        }
    }
}

// MARK: - Private

private extension SearchViewController {
    func configureViews() {
        view.addSubview(visualEffectView)
        
        tableView.dataSource = tableViewProxy
        tableView.delegate = tableViewProxy
        tableView.register(headerFooterClass: SectionHeaderView.self)
        tableView.register(cellClass: SearchCell.self)
        tableView.backgroundColor = UIColor.clear
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        view.addSubview(tableView)

        let emptyImage = UIImage(named: "icn-search")
        let emptyTitle = Model.searchEmptyTitle
        let emptyMessage = Model.searchEmptyMessage
        let emptyInfo = DefaultViewStateInfo(image: emptyImage, title: emptyTitle, message: emptyMessage)
        defaultView.set(info: emptyInfo, state: .empty)
        view.addSubview(defaultView)
    }

    func configureLayout() {
        visualEffectView.edgeAnchors == edgeAnchors
        
        tableView.edgeAnchors == edgeAnchors

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
        guard let _ = dataSource.title(for: section) else {
            return 0.0
        }

        return SectionHeaderView.height
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = dataSource.title(for: section) else {
            return nil
        }

        let headerView = tableView.dequeueHeaderFooterView() as SectionHeaderView
        headerView.contentView.backgroundColor = UIColor.clear
        headerView.configure(with: title)

        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        guard let searchable = dataSource.item(at: indexPath) else {
            return
        }

        delegate?.didSelect(item: searchable)
    }
}

// MARK: - SearchBarProxyDelegate

extension SearchViewController: SearchBarProxyDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
        dataSource.search(for: nil)

        delegate?.didSelectCancel()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataSource.search(for: searchText)
    }

    func searchBarTextWillBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)

        delegate?.willBeginEditing()
    }
}
