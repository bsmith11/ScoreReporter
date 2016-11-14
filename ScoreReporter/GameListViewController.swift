//
//  GameListViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/25/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import KVOController

class GameListViewController: UIViewController {
    fileprivate let dataSource: GameListDataSource
    fileprivate let collectionView: UICollectionView
    fileprivate let defaultView = DefaultView(frame: .zero)
    
    init(dataSource: GameListDataSource) {
        self.dataSource = dataSource
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16.0
        layout.minimumInteritemSpacing = 16.0
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
        
        title = dataSource.title
        
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
        
        dataSource.fetchedChangeHandler = { [weak self] changes in
            self?.collectionView.handle(changes: changes)
        }
    }
}

// MARK: - Private

private extension GameListViewController {
    func configureViews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellClass: GameCell.self)
        collectionView.register(supplementaryClass: SectionHeaderReusableView.self, elementKind: UICollectionElementKindSectionHeader)
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        collectionView.delaysContentTouches = false
        collectionView.contentInset.top = 16.0
        view.addSubview(collectionView)
        
        view.addSubview(defaultView)
    }
    
    func configureLayout() {
        collectionView.edgeAnchors == edgeAnchors
        
        defaultView.edgeAnchors == collectionView.edgeAnchors
    }
    
    func configureObservers() {
        kvoController.observe(dataSource, keyPath: "empty") { [weak self] (empty: Bool) in
            self?.defaultView.empty = empty
        }
    }
}

// MARK: - UICollectionViewDataSource

extension GameListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(for: indexPath) as GameCell
        let game = dataSource.item(at: indexPath)
        let gameViewModel = GameViewModel(game: game)
        
        cell.configure(with: gameViewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueSupplementaryView(for: kind, indexPath: indexPath) as SectionHeaderReusableView
        
        let title = dataSource.title(for: indexPath.section)
        headerView.configure(with: title)
        
        return headerView
    }
}

// MARK: - UICollectionViewDelegate

extension GameListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let game = dataSource.item(at: indexPath), let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        
        let gameViewModel = GameViewModel(game: game)
        let width = collectionView.bounds.width - (layout.sectionInset.left + layout.sectionInset.right)
        
        return GameCell.size(with: gameViewModel, width: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let title = dataSource.title(for: section) else {
            return .zero
        }
        
        let height = SectionHeaderReusableView.height(with: title)
        
        return CGSize(width: collectionView.bounds.width, height: height)
    }
}
