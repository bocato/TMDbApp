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
    let titleAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.black]
    let textAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray]
    
    // MARK: Computed Properties
    var invalidInfoAttributedTitleAndYear: NSAttributedString {
        return NSAttributedString(string: "Unknown", attributes: titleAttributes)
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    // MARK: - Configuration
    private func createMovieLabelAttributedString(for movie: Movie!) -> NSAttributedString {
        guard let title = movie.title, let year = Date.new(from: movie.releaseDate!, format: "yyyy-MM-dd")?.stringWithFormat("yyyy") else { return invalidInfoAttributedTitleAndYear }
        let attributedString = NSMutableAttributedString(string: title, attributes: titleAttributes)
        attributedString.append(NSAttributedString(string: " (\(year))", attributes: textAttributes))
        return attributedString
    }
    
    func configure(with movie: Movie?) {
        guard let movie = movie else { return }
        posterImageView.setImage(with: movie.posterURLString, placeholderImage: UIImage.fromResource(named: .moviePlaceholder))
        movieLabel.attributedText = createMovieLabelAttributedString(for: movie)
    }
    
    func cancelDownloadTask() {
        posterImageView.cancelDownloadTask()
    }
    
}
