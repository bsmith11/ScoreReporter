//
//  HomeViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import KVOController

class HomeViewController: UIViewController, MessageDisplayable {
    private let viewModel: HomeViewModel
    private let dataSource: HomeDataSource
    private let collectionView: UICollectionView
    private let defaultView = DefaultView(frame: .zero)
    
    private var selectedCell: UICollectionViewCell?
        
    override var topLayoutGuide: UILayoutSupport {
        configureMessageView(super.topLayoutGuide)
        
        return messageLayoutGuide
    }
    
    init(viewModel: HomeViewModel, dataSource: HomeDataSource) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.minimumLineSpacing = 16.0
        layout.minimumInteritemSpacing = 16.0
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(nibName: nil, bundle: nil)
        
        title = "Home"
        
        let image = UIImage(named: "icn-home")
        let selectedImage = UIImage(named: "icn-home-selected")
        tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        
        configureViews()
        configureLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureObservers()
        
        dataSource.fetchedChangeHandler = { [weak self] changes in
            self?.collectionView.reloadData()
        }
        
        viewModel.downloadEvents()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let width = collectionView.bounds.width - layout.sectionInset.left - layout.sectionInset.right
        
        guard width > 0.0 && width != layout.estimatedItemSize.width else {
            return
        }

        layout.estimatedItemSize = CGSize(width: width, height: 44.0)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        transitionCoordinator()?.animateAlongsideTransition(nil, completion: { [weak self] _ in
            self?.selectedCell?.hidden = false
        })
    }
}

// MARK: - Private

private extension HomeViewController {
    func configureViews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(HomeCell)
        collectionView.registerClass(SectionHeaderReusableView.self, elementKind: UICollectionElementKindSectionHeader)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.alwaysBounceVertical = true
        collectionView.delaysContentTouches = false
        view.addSubview(collectionView)
        
        let emptyImage = UIImage(named: "icn-home")
        let emptyTitle = "No Events"
        let emptyMessage = "Nothing is happening this week"
        let emptyInfo = DefaultViewStateInfo(image: emptyImage, title: emptyTitle, message: emptyMessage)
        defaultView.setInfo(emptyInfo, state: .Empty)
        view.addSubview(defaultView)
    }
    
    func configureLayout() {
        collectionView.edgeAnchors == edgeAnchors

        defaultView.edgeAnchors == collectionView.edgeAnchors
    }
    
    func configureObservers() {
        KVOController.observe(dataSource, keyPath: "empty") { [weak self] (empty: Bool) in
            self?.defaultView.empty = empty
        }
        
        KVOController.observe(viewModel, keyPath: "loading") { [weak self] (loading: Bool) in
            if loading {
                self?.displayMessage("Loading...", animated: true)
            }
            else {
                self?.hideMessageAnimated(true)
            }
        }
        
        KVOController.observe(viewModel, keyPath: "error") { [weak self] (error: NSError) in
            self?.displayMessage("Error", animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSections()
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfItemsInSection(section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCellForIndexPath(indexPath) as HomeCell
        let event = dataSource.itemAtIndexPath(indexPath)
        
        cell.configureWithSearchable(event)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueSupplementaryViewForElementKind(kind, indexPath: indexPath) as SectionHeaderReusableView
        
        let title = dataSource.titleForSection(indexPath.section)
        headerView.configureWithTitle(title)//, actionButtonImage: UIImage(named: "icn-search"))
        headerView.delegate = self
        
        return headerView
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let event = dataSource.itemAtIndexPath(indexPath) else {
            return
        }
        
        selectedCell = collectionView.cellForItemAtIndexPath(indexPath)
        
        let eventDetailsViewModel = EventDetailsViewModel(event: event)
        let eventDetailsDataSource = EventDetailsDataSource(event: event)
        let eventDetailsViewController = EventDetailsViewController(viewModel: eventDetailsViewModel, dataSource: eventDetailsDataSource)
        
        navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }
        
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let title = dataSource.titleForSection(section)
        let height = SectionHeaderReusableView.heightWithTitle(title, actionButtonImage: UIImage(named: "icn-search"))
        
        return CGSize(width: collectionView.bounds.width, height: height)
    }
}

// MARK: - SectionHeaderReusableViewDelegate

extension HomeViewController: SectionHeaderReusableViewDelegate {
    func headerViewDidSelectActionButton(headerView: SectionHeaderReusableView) {
        let searchViewController = SearchViewController<Event>()
        searchViewController.delegate = self
        navigationController?.pushViewController(searchViewController, animated: true)
    }
}

// MARK: - SearchViewControllerDelegate

extension HomeViewController: SearchViewControllerDelegate {
    func didSelectItem(item: Searchable) {
        guard let event = item as? Event else {
            return
        }
        
        let eventDetailsViewModel = EventDetailsViewModel(event: event)
        let eventDetailsDataSource = EventDetailsDataSource(event: event)
        let eventDetailsViewController = EventDetailsViewController(viewModel: eventDetailsViewModel, dataSource: eventDetailsDataSource)
        navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }
}

// MARK: - ListDetailAnimationControllerDelegate

extension HomeViewController: ListDetailAnimationControllerDelegate {
    var viewToAnimate: UIView {
        guard let cell = selectedCell as? HomeCell,
                  frame = navigationController?.view.convertRect(cell.frame, fromView: cell.superview) else {
            return UIView()
        }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0);
        cell.drawViewHierarchyInRect(cell.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageView = UIImageView(frame: frame)
        imageView.image = image
        
        cell.hidden = true
        
        return imageView
    }
}
