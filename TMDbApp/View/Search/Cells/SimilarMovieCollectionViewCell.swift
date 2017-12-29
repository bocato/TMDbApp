//
//  SimilarMovieCollectionViewCell.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 29/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

class SimilarMovieCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var posterImageView: UIImageView!
    
    // MARK: - Configuration
    func configure(with movie: Movie?){
        guard let posterURLString = movie?.posterURLString else { return }
        posterImageView.setImage(with: posterURLString, placeholderImage: UIImage.fromResource(named: .moviePlaceholder))
    }
    
    // MARK: KingFisher
    func cancelDownloadTask() {
        posterImageView.cancelDownloadTask()
    }
    
}
