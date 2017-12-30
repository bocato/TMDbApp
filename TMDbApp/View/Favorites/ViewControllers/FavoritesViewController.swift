//
//  FavoritesController.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

fileprivate struct ViewConstants {
    static let favoriteCollectionViewCellHeight: CGFloat = 320
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadViewData()
    }
    
    // MARK: - Configuration
    func configureCollectionView() {
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    // MARK: API / LocalDatabase Calls
    func loadViewData(){
        favoriteMovies = ApplicationData.shared.favoriteMovies
        self.collectionView.reloadData()
    }

}

// MARK: - UICollectionViewDataSource
extension FavoritesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteMovies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.identifier, for: indexPath) as! FavoriteCollectionViewCell
        cell.configure(with: favoriteMovies?[indexPath.row])
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension FavoritesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? FavoriteCollectionViewCell)?.cancelDownloadTask()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movie = favoriteMovies?[indexPath.row], let cell = collectionView.cellForItem(at: indexPath) {
            presentTransition.startingPoint = cell.center
            dismissTransition.animatedTransitionStartPoint = cell.center
            NavigationRouter().perform(segue: .favoriteMovieDetails, from: self, info: movie, completion: nil)
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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

