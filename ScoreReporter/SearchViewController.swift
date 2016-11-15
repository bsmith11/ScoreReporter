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
    func didSelect(item: Searchable)
}

class SearchViewController<Model: Searchable>: UIViewController {
    fileprivate let dataSource: SearchDataSource<Model>
    fileprivate let searchBar = UISearchBar(frame: .zero)
    fileprivate let collectionView: UICollectionView
    fileprivate let defaultView = DefaultView(frame: .zero)
    
    fileprivate var collectionViewProxy: CollectionViewProxy?
    fileprivate var searchBarProxy: SearchBarProxy?
    fileprivate var selectedCell: UICollectionViewCell?
    
    weak var delegate: SearchViewControllerDelegate?
    
    init() {
        dataSource = SearchDataSource<Model>()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: TableCollectionViewLayout())
        
        super.init(nibName: nil, bundle: nil)
        
        collectionViewProxy = CollectionViewProxy(dataSource: self, delegate: self)
        searchBarProxy = SearchBarProxy(delegate: self)
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
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
            self?.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        transitionCoordinator?.animate(alongsideTransition: nil) { [weak self] _ in
            self?.searchBar.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
        
        var frame = navigationController?.navigationBar.frame ?? .zero
        frame.size.width = frame.width - (8.0 + 8.0 + 13.0 + 16.0)
        frame.origin.x = CGFloat(8.0 + 13.0 + 16.0)
        searchBar.frame = frame
        
        navigationItem.titleView = searchBar
        
        collectionView.dataSource = collectionViewProxy
        collectionView.delegate = collectionViewProxy
        collectionView.register(supplementaryClass: SectionHeaderReusableView.self, elementKind: UICollectionElementKindSectionHeader)
        collectionView.register(cellClass: SearchCell.self)
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        collectionView.delaysContentTouches = false
        view.addSubview(collectionView)
        
        let emptyImage = UIImage(named: "icn-search")
        let emptyTitle = Model.searchEmptyTitle
        let emptyMessage = Model.searchEmptyMessage
        let emptyInfo = DefaultViewStateInfo(image: emptyImage, title: emptyTitle, message: emptyMessage)
        defaultView.setInfo(emptyInfo, state: .empty)
        view.addSubview(defaultView)
    }
    
    func configureLayout() {
        collectionView.topAnchor == topLayoutGuide.bottomAnchor
        collectionView.horizontalAnchors == horizontalAnchors
        collectionView.keyboardLayoutGuide.bottomAnchor == bottomLayoutGuide.topAnchor
        
        defaultView.edgeAnchors == collectionView.edgeAnchors
    }
    
    func configureObservers() {
        kvoController.observe(dataSource, keyPath: "empty") { [weak self] (empty: Bool) in
            self?.defaultView.empty = empty
        }
    }
}

// MARK: - CollectionViewProxyDataSource

extension SearchViewController: CollectionViewProxyDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(for: indexPath) as SearchCell
        let searchable = dataSource.item(at: indexPath)
        
        cell.configure(with: searchable)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueSupplementaryView(for: kind, indexPath: indexPath) as SectionHeaderReusableView
        
        let title = dataSource.title(for: indexPath.section)
        headerView.configure(with: title)
        
        return headerView
    }
}

// MARK: - CollectionViewProxyDelegate

extension SearchViewController: CollectionViewProxyDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let searchable = dataSource.item(at: indexPath) else {
            return
        }
        
        selectedCell = collectionView.cellForItem(at: indexPath)
        
        delegate?.didSelect(item: searchable)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let searchable = dataSource.item(at: indexPath), let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        
        let width = collectionView.bounds.width - (layout.sectionInset.left + layout.sectionInset.right)
        
        return SearchCell.size(with: searchable, width: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let title = dataSource.title(for: section) else {
            return .zero
        }
        
        let height = SectionHeaderReusableView.height(with: title)
        
        return CGSize(width: collectionView.bounds.width, height: height)
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
    var viewToAnimate: UIView {
        guard let cell = selectedCell as? SearchCell,
              let frame = navigationController?.view.convert(cell.frame, from: cell.superview) else {
            return UIView()
        }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0);
        cell.drawHierarchy(in: cell.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageView = UIImageView(frame: frame)
        imageView.image = image
        
        cell.isHidden = true
        
        return imageView
    }
}
