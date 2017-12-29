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
    
    // MARK: - Computed Properties
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        loadViewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    // MARK: - Configuration
    func configureCollectionView() {
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    // MARK: API / LocalDatabase Calls
    func loadViewData(){
        favoriteMovies = ApplicationData.shared.favoriteMovies
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
        if let movie = favoriteMovies?[indexPath.row] {
//            presentStoryAnimationController.selectedCardFrame = cell.frame
//            dismissStoryAnimationController.selectedCardFrame = cell.frame
//            performSegue(withIdentifier: "presentStory", sender: self)
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return CGSize(width: collectionView.bounds.width, height: ViewConstants.favoriteCollectionViewCellHeight)
        } else {
            // TODO: Check this...
            let numberOfItemsInRow = 2
            let rowNumber = indexPath.item/numberOfItemsInRow
            let compressedWidth = collectionView.bounds.width/3
            let expandedWidth = (collectionView.bounds.width/3) * 2
            let isEvenRow = rowNumber % 2 == 0
            let isFirstItem = indexPath.item % numberOfItemsInRow != 0
            var width: CGFloat = 0.0
            if isEvenRow {
                width = isFirstItem ? compressedWidth : expandedWidth
            } else {
                width = isFirstItem ? expandedWidth : compressedWidth
            }
            let size = CGSize(width: width, height: ViewConstants.favoriteCollectionViewCellHeight)
            return size
        }
    }
    
}

extension FavoritesViewController {
    
    // MARK: - Instantiation
    static func instantiate(fromStoryboard storyboard: UIStoryboard) -> FavoritesViewController {
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! FavoritesViewController
    }
    
}

