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
    fileprivate let viewModel: HomeViewModel
    fileprivate let dataSource: HomeDataSource
    fileprivate let collectionView: UICollectionView
    fileprivate let defaultView = DefaultView(frame: .zero)
    
    fileprivate var selectedCell: UICollectionViewCell?
        
    override var topLayoutGuide: UILayoutSupport {
        configureMessageView(super.topLayoutGuide)
        
        return messageLayoutGuide
    }
    
    init(viewModel: HomeViewModel, dataSource: HomeDataSource) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
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
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        transitionCoordinator?.animate(alongsideTransition: nil, completion: { [weak self] _ in
            self?.selectedCell?.isHidden = false
        })
    }
}

// MARK: - Private

private extension HomeViewController {
    func configureViews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellClass: HomeCell.self)
        collectionView.register(supplementaryClass: SectionHeaderReusableView.self, elementKind: UICollectionElementKindSectionHeader)
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        collectionView.delaysContentTouches = false
        view.addSubview(collectionView)
        
        let emptyImage = UIImage(named: "icn-home")
        let emptyTitle = "No Events"
        let emptyMessage = "Nothing is happening this week"
        let emptyInfo = DefaultViewStateInfo(image: emptyImage, title: emptyTitle, message: emptyMessage)
        defaultView.setInfo(emptyInfo, state: .empty)
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
        
        kvoController.observe(viewModel, keyPath: "loading") { [weak self] (loading: Bool) in
            if loading {
                self?.display(message: "Loading...", animated: true)
            }
            else {
                self?.hideMessage(animated: true)
            }
        }
        
        kvoController.observe(viewModel, keyPath: "error") { [weak self] (error: NSError) in
            self?.display(message: "Error", animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSections()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(for: indexPath) as HomeCell
        let event = dataSource.item(at: indexPath)
        
        cell.configure(with: event)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueSupplementaryView(for: kind, indexPath: indexPath) as SectionHeaderReusableView
        
        let title = dataSource.title(for: indexPath.section)
        headerView.configure(with: title)
        headerView.delegate = self
        
        return headerView
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let event = dataSource.item(at: indexPath) else {
            return
        }
        
        selectedCell = collectionView.cellForItem(at: indexPath)
        
        let eventDetailsViewModel = EventDetailsViewModel(event: event)
        let eventDetailsDataSource = EventDetailsDataSource(event: event)
        let eventDetailsViewController = EventDetailsViewController(viewModel: eventDetailsViewModel, dataSource: eventDetailsDataSource)
        
        navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let title = dataSource.title(for: section)
        let height = SectionHeaderReusableView.height(with: title)
        
        return CGSize(width: collectionView.bounds.width, height: height)
    }
}

// MARK: - SectionHeaderReusableViewDelegate

extension HomeViewController: SectionHeaderReusableViewDelegate {
    func headerViewDidSelectActionButton(_ headerView: SectionHeaderReusableView) {
        let searchViewController = SearchViewController<Event>()
        searchViewController.delegate = self
        navigationController?.pushViewController(searchViewController, animated: true)
    }
}

// MARK: - SearchViewControllerDelegate

extension HomeViewController: SearchViewControllerDelegate {
    func didSelectItem(_ item: Searchable) {
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
