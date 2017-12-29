//
//  SearchResultDetailViewController.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 29/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

class SearchResultDetailViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    
    // MARK: Constants
    let titleAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.black]
    let textAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray]
    
    // MARK: Properties
    var movie: Movie!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadViewData()
    }
    
    // MARK: - UI
    func configureUI() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.title = "Details"
    }
    
    func loadViewData() {
        guard let posterURLString = movie.posterURLString, let title = movie.title, let releaseDate = movie.releaseDate, let formattedReleaseDate = Date.new(from: releaseDate, format: "yyyy-MM-dd")?.stringWithFormat("dd/MM/yyyy"), let genresString = movie.genresString, let overview = movie.overview else { return }
        
        posterImageView.setImage(with: posterURLString, placeholderImage: UIImage.fromResource(named: .moviePlaceholder))
        titleLabel.attributedText = attributedString(with: "Title: ", text: title)
        releaseDateLabel.attributedText = attributedString(with: "Release date: ", text: formattedReleaseDate)
        genresLabel.attributedText = attributedString(with: "Genres: ", text: genresString)
        overviewTextView.text = overview
    }

    // MARK: - Helpers
    func attributedString(with title: String!, text: String!) ->  NSAttributedString{
        let attributedString = NSMutableAttributedString(string: title, attributes: titleAttributes)
        attributedString.append(NSAttributedString(string: text, attributes: textAttributes))
        return attributedString
    }
    
}

// MARK: - Instantiation
extension SearchResultDetailViewController {
    
    static func instantiate(fromStoryboard storyboard: UIStoryboard) -> SearchResultDetailViewController {
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! SearchResultDetailViewController
    }
    
}

