//
//  EventDetailsViewController.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/17/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage
import KVOController

class EventDetailsViewController: UIViewController, MessageDisplayable {
    fileprivate let viewModel: EventDetailsViewModel
    fileprivate let dataSource: EventDetailsDataSource
    fileprivate let collectionView: UICollectionView
    
    fileprivate var favoriteButton: UIBarButtonItem?
    fileprivate var unfavoriteButton: UIBarButtonItem?
    fileprivate var eventCell: UICollectionViewCell?
    fileprivate var viewDidAppear = false
    
    override var topLayoutGuide: UILayoutSupport {
        configureMessageView(super.topLayoutGuide)
        
        return messageLayoutGuide
    }
    
    init(viewModel: EventDetailsViewModel, dataSource: EventDetailsDataSource) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24.0
        layout.minimumInteritemSpacing = 24.0
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
        
        title = "Event Details"
        
        let favoriteImage = UIImage(named: "icn-star")
        favoriteButton = UIBarButtonItem(image: favoriteImage, style: .plain, target: self, action: #selector(favoriteButtonTapped))
        
        let unfavoriteImage = UIImage(named: "icn-star-selected")
        unfavoriteButton = UIBarButtonItem(image: unfavoriteImage, style: .plain, target: self, action: #selector(unfavoriteButtonTapped))
        
        navigationItem.rightBarButtonItem = dataSource.event.bookmarked.boolValue ? unfavoriteButton : favoriteButton
        
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
        view.backgroundColor = UIColor.white
        
        configureViews()
        configureLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.refreshBlock = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.downloadEventDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.navigationController?.navigationBar.barTintColor = UIColor.scBlue
        }, completion: { [weak self] _ in
            self?.eventCell?.isHidden = false
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !viewDidAppear {
            viewDidAppear = true
            
            configureObservers()
        }
    }
}

// MARK: - Private

private extension EventDetailsViewController {
    func configureViews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(supplementaryClass: SectionHeaderReusableView.self, elementKind: UICollectionElementKindSectionHeader)
        collectionView.register(cellClass: EventCell.self)
        collectionView.register(cellClass: GroupCell.self)
        collectionView.register(cellClass: GameCell.self)
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        collectionView.delaysContentTouches = false
        view.addSubview(collectionView)
    }
    
    func configureLayout() {
        collectionView.edgeAnchors == edgeAnchors
    }
    
    func configureObservers() {
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
    
    @objc func favoriteButtonTapped() {
        navigationItem.setRightBarButton(unfavoriteButton, animated: true)
        
        let event = dataSource.event
        event.bookmarked = true
        
        do {
            try event.managedObjectContext?.save()
        }
        catch let error {
            print("Error: \(error)")
        }
    }
    
    @objc func unfavoriteButtonTapped() {
        navigationItem.setRightBarButton(favoriteButton, animated: true)
        
        let event = dataSource.event
        event.bookmarked = false
        
        do {
            try event.managedObjectContext?.save()
        }
        catch let error {
            print("Error: \(error)")
        }
    }
}

// MARK: - UICollectionViewDataSource

extension EventDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = dataSource.item(at: indexPath) else {
            return UICollectionViewCell()
        }
        
        switch item {
        case .event(let event):
            let cell = collectionView.dequeueCell(for: indexPath) as EventCell
            eventCell = cell
            cell.isHidden = !viewDidAppear
            cell.configure(with: event)
            return cell
        case .division(let group):
            let groupViewModel = GroupViewModel(group: group)
            let cell = collectionView.dequeueCell(for: indexPath) as GroupCell
            cell.configure(with: groupViewModel)
            return cell
        case .activeGame(let game):
            let gameViewModel = GameViewModel(game: game)
            let cell = collectionView.dequeueCell(for: indexPath) as GameCell
            cell.configure(with: gameViewModel)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let title = dataSource.title(for: indexPath.section)
        let headerView = collectionView.dequeueSupplementaryView(for: kind, indexPath: indexPath) as SectionHeaderReusableView
        headerView.configure(with: title)
        
        return headerView
    }
}

// MARK: - UICollectionViewDelegate

extension EventDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.item(at: indexPath) else {
            return
        }
        
        switch item {
        case .division(let group):
            let groupDetailsDataSource = GroupDetailsDataSource(group: group)
            let groupDetailsViewController = GroupDetailsViewController(dataSource: groupDetailsDataSource)
            navigationController?.pushViewController(groupDetailsViewController, animated: true)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = dataSource.item(at: indexPath), let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        
        let width = collectionView.bounds.width - (layout.sectionInset.left + layout.sectionInset.right)
        
        switch item {
        case .event(let event):
            return EventCell.size(with: event, width: width)
        case .division(let group):
            let groupViewModel = GroupViewModel(group: group)
            return GroupCell.size(with: groupViewModel, width: width)
        case .activeGame(let game):
            let gameViewModel = GameViewModel(game: game)
            return GameCell.size(with: gameViewModel, width: width)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let title = dataSource.title(for: section) else {
            return .zero
        }
        
        let height = SectionHeaderReusableView.height(with: title)
        
        return CGSize(width: collectionView.bounds.width, height: height)
    }
}

//// MARK: - UITableViewDelegate
//
//extension EventDetailsViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let item = dataSource.item(at: indexPath) else {
//            return
//        }
//        
//        switch item {
//        case .address:
//            let eventViewModel = EventViewModel(event: dataSource.event)
//            
//            guard  let coordinate = eventViewModel.coordinate else {
//                return
//            }
//            
//            let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
//            let mapItem = MKMapItem(placemark: placemark)
//            mapItem.name = eventViewModel.name
//            
//            let options = [
//                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
//            ]
//            mapItem.openInMaps(launchOptions: options)
//            
//            tableView.deselectRow(at: indexPath, animated: true)
//        case .date:
//            break
//        case .division(let group):
//            let groupDetailsDataSource = GroupDetailsDataSource(group: group)
//            let groupDetailsViewController = GroupDetailsViewController(dataSource: groupDetailsDataSource)
//            
//            navigationController?.pushViewController(groupDetailsViewController, animated: true)
//        default:
//            break
//        }
//    }
//}
