//
//  EventListViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 7/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

class EventListViewController: UIViewController {
    private let viewModel: EventListViewModel
    private let collectionView: UICollectionView

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    init(viewModel: EventListViewModel) {
        self.viewModel = viewModel

        let layout = EventListCollectionViewLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(nibName: nil, bundle: nil)

        title = "Events"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView()

        configureViews()
        configureLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.changeHandler = { [weak self] (changes: [FetchedChange]) in
            self?.collectionView.handleChanges(changes)
        }
    }
}

// MARK: - Private

private extension EventListViewController {
    func configureViews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(EventListCell.self)
        collectionView.registerClass(EventListHeaderView.self, elementKind: UICollectionElementKindSectionHeader)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.alwaysBounceVertical = true
        collectionView.delaysContentTouches = false
        view.addSubview(collectionView)
    }

    func configureLayout() {
        collectionView.edgeAnchors == view.edgeAnchors
    }
}

// MARK: - UICollectionViewDataSource

extension EventListViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCellForIndexPath(indexPath) as EventListCell
        let event = viewModel.itemAtIndexPath(indexPath)
        let eventViewModel = EventViewModel(event: event)

        cell.configureWithViewModel(eventViewModel)

        return cell
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueSupplementaryViewForElementKind(UICollectionElementKindSectionHeader, indexPath: indexPath) as EventListHeaderView
        let event = viewModel.itemAtIndexPath(indexPath)
        let eventViewModel = EventViewModel(event: event)

        headerView.configureWithViewModel(eventViewModel)

        return headerView
    }
}

// MARK: - UICollectionViewDelegate

extension EventListViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        let event = viewModel.itemAtIndexPath(indexPath)
//        let eventViewModel = EventViewModel(event: event)
    }
}
