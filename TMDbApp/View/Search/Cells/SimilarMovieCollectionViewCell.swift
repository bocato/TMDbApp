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
    @IBOutlet private weak var titleAndYearLabel: UILabel!
    
    // MARK: Constants
    let titleAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.lightGray]
    let dateAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.lightGray]
    
    // MARK: Computed Properties
    var invalidInfoAttributedTitleAndYear: NSAttributedString {
        return NSAttributedString(string: "Unknown", attributes: titleAttributes)
    }
    
    // MARK: - Configuration
    private func createMovieLabelAttributedString(for movie: Movie!) -> NSAttributedString {
        guard let title = movie.title, let year = Date.new(from: movie.releaseDate!, format: "yyyy-MM-dd")?.stringWithFormat("yyyy")else { return invalidInfoAttributedTitleAndYear }
        let attributedString = NSMutableAttributedString(string: title, attributes: titleAttributes)
        attributedString.append(NSAttributedString(string: " (\(year))", attributes: dateAttributes))
        return attributedString
    }
    
    func configure(with movie: Movie?){
        guard let movie = movie else { return }
        configurePoster(for: movie)
        titleAndYearLabel.attributedText = createMovieLabelAttributedString(for: movie)
        titleAndYearLabel.configureShadow()
    }
    
    private func configurePoster(for movie: Movie!){
        guard let posterURLString = movie.posterURLString else {
            posterImageView.image = UIImage.fromResource(named: .noPoster)
            return
        }
        posterImageView.setImage(with: posterURLString, placeholderImage: UIImage.fromResource(named: .loadingMoviePoster), imageForError: UIImage.fromResource(named: .noPoster), downloadedImageContentMode: .scaleAspectFit)
    }
    
    // MARK: KingFisher
    func cancelDownloadTask() {
        posterImageView.cancelDownloadTask()
    }
    
}
