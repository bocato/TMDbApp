//
//  SearchResultTableViewCell.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var posterImageView: UIImageView!
    @IBOutlet fileprivate weak var movieLabel: UILabel!
    
    // MARK: Constants
    let titleAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.black]
    let dateAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.lightGray]
    let genresAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.lightGray]
    
    // MARK: Computed Properties
    var invalidInfoAttributedTitleAndYear: NSAttributedString {
        return NSAttributedString(string: "Unknown", attributes: titleAttributes)
    }

    // MARK: - Lifecycle
    deinit {
        posterImageView.cancelDownloadTask()
    }
    
    // MARK: - Configuration    
    private func createMovieLabelAttributedString(for movie: Movie!) -> NSAttributedString {
        guard let title = movie.title, let year = Date.new(from: movie.releaseDate!, format: "yyyy-MM-dd")?.stringWithFormat("yyyy"), let genresString = movie.genresString else { return invalidInfoAttributedTitleAndYear }
        let attributedString = NSMutableAttributedString(string: title, attributes: titleAttributes)
        attributedString.append(NSAttributedString(string: " (\(year))", attributes: dateAttributes))
        attributedString.append(NSAttributedString(string: "\n" + genresString, attributes: genresAttributes))
        return attributedString
    }
    
    private func configurePoster(for movie: Movie!){
        guard let posterURLString = movie.posterURLString else {
            posterImageView.image = UIImage.fromResource(named: .moviePlaceholder)
            return
        }
        posterImageView.setImage(with: posterURLString, imageForError: UIImage.fromResource(named: .moviePlaceholder), downloadedImageContentMode: .scaleAspectFit)
    }
    
    func configure(with movie: Movie?) {
        guard let movie = movie else { return }
        configurePoster(for: movie)
        movieLabel.attributedText = createMovieLabelAttributedString(for: movie)
    }
    
}
