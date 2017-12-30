//
//  FavoritesController.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit
import Kingfisher

fileprivate struct ViewConstants {
    static let favoriteCollectionViewCellHeight: CGFloat = 320
    static let noFavoritesCollectionViewCellIdentifier = "NoFavoritesCollectionViewCell"
}

class FavoritesViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var favoriteMovies: [Movie]?
    private let presentTransition: BubbleTransition = ({
        let transition = BubbleTransition()
        transition.transitionMode = .present
        transition.bubbleColor = UIColor.white
        return transition
    })()
    private let dismissTransition = DismissFavoriteAnimationController()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavigationBarButtonItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadViewData()
    }
    
    deinit {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
    }
    
    // MARK: - Configuration
    func configureCollectionView() {
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    func configureNavigationBarButtonItems() {
        navigationItem.hidesBackButton = true
        if let _ = navigationController {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sort", style: .done, target: self, action: #selector(FavoritesViewController.filterBarButtonItemDidReceiveTouchUpInside(_:)))
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(FavoritesViewController.trashBarButtonItemDidReceiveTouchUpInside(_:)))
        }
    }
    
    func updateBarButtonItemsState() {
        var enableBarButtonItems = false
        if let favoriteMovies = favoriteMovies, favoriteMovies.count >  0 {
            enableBarButtonItems = true
        }
        navigationItem.leftBarButtonItem?.isEnabled = enableBarButtonItems
        navigationItem.rightBarButtonItem?.isEnabled = enableBarButtonItems
    }
    
    // MARK: LocalDatabase Calls
    func loadViewData(fetchLocalDatabase: Bool = true){
        if fetchLocalDatabase {
            favoriteMovies = ApplicationData.favoriteMovies
        }
        updateBarButtonItemsState()
        self.collectionView.reloadData()
    }
    
    @objc func reloadViewData() {
        loadViewData(fetchLocalDatabase: true)
    }

    // MARK: - Selectors
    @objc func trashBarButtonItemDidReceiveTouchUpInside(_ sender: UIBarButtonItem){
        let bottomAlertController = BottomAlertController.instantiateNew(withTitle: "Alert", text: "Do you really want to delete all your favorites?", leftButtonTitle: "No", leftButtonActionClosure: {
            debugPrint("No touched.")
        }, rightButtonTitle: "Yes", rightButtonActionClosure: {
            FavoriteMoviesDatabaseManager.shared.deleteAll(onSuccess: {
                let bottomAlertController = BottomAlertController.instantiateNew(withTitle: "Great!", text: "You deleted all your favorites!", buttonTitle: "Ok", actionClosure: nil)
                self.loadViewData()
                self.tabBarController?.present(bottomAlertController, animated: true, completion: nil)
            }, onFailure: { _ in
                let bottomAlertController = BottomAlertController.instantiateNew(withTitle: "Oops!", text: "An unexpected error ocurred and we could not delete your favorites.", buttonTitle: "Ok", actionClosure: nil)
                self.tabBarController?.present(bottomAlertController, animated: true, completion: nil)
            })
        })
        self.tabBarController?.present(bottomAlertController, animated: true, completion: nil)
    }
    
    @objc func filterBarButtonItemDidReceiveTouchUpInside(_ sender: UIBarButtonItem){
        
        let alertController = UIAlertController(title: "Sort Favorites", message: nil, preferredStyle: .actionSheet)
        
        let sortByTitleAction = UIAlertAction(title: "Title", style: .default) { _ in
            if let favoriteMovies = self.favoriteMovies, favoriteMovies.count > 0{
                self.favoriteMovies = ApplicationData.favoriteMovies?.sorted(by: { (movie1, movie2) -> Bool in
                    guard let title1 = movie1.title, let title2 = movie2.title else {
                        return false
                    }
                    return title1 < title2
                })
                self.loadViewData(fetchLocalDatabase: false)
                alertController.dismiss(animated: true, completion: nil)
            }
        }
        sortByTitleAction.setValue(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0), forKey: "titleTextColor")
        alertController.addAction(sortByTitleAction)
        
        let sortByMostRecentReleaseDate = UIAlertAction(title: "Most Recent", style: .default) { _ in
            if let favoriteMovies = self.favoriteMovies, favoriteMovies.count > 0 {
                self.favoriteMovies = ApplicationData.favoriteMovies?.sorted(by: { (movie1, movie2) -> Bool in
                    guard let movie1ReleaseDate = movie1.releaseDate, let releaseDate1 = Date.new(from: movie1ReleaseDate, format: "yyyy-MM-dd"), let movie2ReleaseDate = movie2.releaseDate, let releaseDate2 = Date.new(from: movie2ReleaseDate, format: "yyyy-MM-dd") else {
                        return false
                    }
                    return releaseDate1 > releaseDate2
                })
                self.loadViewData(fetchLocalDatabase: false)
                alertController.dismiss(animated: true, completion: nil)
            }
        }
        sortByMostRecentReleaseDate.setValue(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0), forKey: "titleTextColor")
        alertController.addAction(sortByMostRecentReleaseDate)
        
        let sortByLeastRecentReleaseDate = UIAlertAction(title: "Least Recent", style: .default) { _ in
            if let favoriteMovies = self.favoriteMovies, favoriteMovies.count > 0 {
                self.favoriteMovies = ApplicationData.favoriteMovies?.sorted(by: { (movie1, movie2) -> Bool in
                    guard let movie1ReleaseDate = movie1.releaseDate, let releaseDate1 = Date.new(from: movie1ReleaseDate, format: "yyyy-MM-dd"), let movie2ReleaseDate = movie2.releaseDate, let releaseDate2 = Date.new(from: movie2ReleaseDate, format: "yyyy-MM-dd") else {
                        return false
                    }
                    return releaseDate1 > releaseDate2
                })
                self.loadViewData(fetchLocalDatabase: false)
                alertController.dismiss(animated: true, completion: nil)
            }
        }
        sortByLeastRecentReleaseDate.setValue(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0), forKey: "titleTextColor")
        alertController.addAction(sortByLeastRecentReleaseDate)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        
        tabBarController?.present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - UICollectionViewDataSource
extension FavoritesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let favoriteMovies = favoriteMovies, favoriteMovies.count > 0 else { return 1 }
        return favoriteMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let favoriteMovies = favoriteMovies, favoriteMovies.count > 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath) as! FavoriteCollectionViewCell
            cell.configure(with: favoriteMovies[indexPath.row])
            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: ViewConstants.noFavoritesCollectionViewCellIdentifier, for: indexPath)
        }
    }
    
}

// MARK: - UICollectionViewDelegate
extension FavoritesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? FavoriteCollectionViewCell)?.cancelDownloadTask()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let favoriteMovies = favoriteMovies, let cell = collectionView.cellForItem(at: indexPath), favoriteMovies.count > 0 {
            presentTransition.startingPoint = cell.center
            dismissTransition.animatedTransitionStartPoint = cell.center
            let movie = favoriteMovies[indexPath.row]
            NavigationRouter().perform(segue: .favoriteMovieDetails, from: self, info: movie, completion: nil)
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let favoriteMovies = favoriteMovies, favoriteMovies.count > 0 else {
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        }
        return CGSize(width: collectionView.bounds.width, height: ViewConstants.favoriteCollectionViewCellHeight)
    }
    
}

extension FavoritesViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissTransition
    }
    
}

extension FavoritesViewController {
    
    // MARK: - Instantiation
    static func instantiate(fromStoryboard storyboard: UIStoryboard) -> FavoritesViewController {
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! FavoritesViewController
    }
    
}

