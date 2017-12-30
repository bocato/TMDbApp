//
//  SimilarMoviesTableViewCell.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 29/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

protocol SimilarMoviesTableViewCellDataSource {
    func similarMoviesTableViewCell(_ similarMoviesTableViewCell: SimilarMoviesTableViewCell, collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func similarMoviesTableViewCell(_ similarMoviesTableViewCell: SimilarMoviesTableViewCell, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

protocol SimilarMoviesTableViewCellDelegate {
    func similarMoviesTableViewCell(_ similarMoviesTableViewCell: SimilarMoviesTableViewCell, collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    func similarMoviesTableViewCell(_ similarMoviesTableViewCell: SimilarMoviesTableViewCell, collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    func similarMoviesTableViewCellScrollViewDidScroll(_ similarMoviesTableViewCell: SimilarMoviesTableViewCell, collectionView: UICollectionView, scrollView: UIScrollView)
}

class SimilarMoviesTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UPCarouselFlowLayout!
    var dataSource: SimilarMoviesTableViewCellDataSource!
    var delegate: SimilarMoviesTableViewCellDelegate?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }

    // MARK: - Configuration
    private func configureCollectionView(){
        
        var itemSize: CGSize {
            let width = self.collectionView.bounds.size.width * 0.5
            let height = self.collectionView.bounds.size.height * 0.8
            return CGSize(width: width, height: height)
        }
        
        collectionViewLayout.sideItemScale = 0.75
        collectionViewLayout.sideItemAlpha = 0.8
        collectionViewLayout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: -5)
        collectionViewLayout.itemSize = itemSize
        
    }
    
    // MARK: - Helpers
    func reloadCollectionView(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension SimilarMoviesTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.similarMoviesTableViewCell(self, collectionView: collectionView, numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource.similarMoviesTableViewCell(self, collectionView: collectionView, cellForItemAt: indexPath)
    }
    
}

// MARK: - UICollectionViewDelegate
extension SimilarMoviesTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.similarMoviesTableViewCell(self, collectionView: collectionView, didSelectItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegate?.similarMoviesTableViewCell(self, collectionView: collectionView, didEndDisplaying: cell, forItemAt: indexPath)
    }
    
}

// MARK: - UIScrollViewDelegate
extension SimilarMoviesTableViewCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.similarMoviesTableViewCellScrollViewDidScroll(self, collectionView: self.collectionView, scrollView: scrollView)
    }
    
}
