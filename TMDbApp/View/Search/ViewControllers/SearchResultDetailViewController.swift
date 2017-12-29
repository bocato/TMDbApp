//
//  SearchResultDetailViewController.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 29/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit
import NYTPhotoViewer

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
        configureViewElements()
        configureImageViewGestureRecognizer()
        loadViewData()
    }
    
    // MARK: - Configuration
    func configureViewElements() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.title = "Details"
    }
    
    func configureImageViewGestureRecognizer(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchResultDetailViewController.imageViewDidReceiveTouchUpInside(_:)))
        posterImageView.isUserInteractionEnabled = true
        posterImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Selectors
    @objc func imageViewDidReceiveTouchUpInside(_ sender: UITapGestureRecognizer){
        if let image = posterImageView.image {
            let photos = [Photo(image: image)]
            let photosViewController = NYTPhotosViewController(photos: photos)
            present(photosViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Helpers
    func attributedString(with title: String!, text: String!) ->  NSAttributedString{
        let attributedString = NSMutableAttributedString(string: title, attributes: titleAttributes)
        attributedString.append(NSAttributedString(string: text, attributes: textAttributes))
        return attributedString
    }
    
    // MARK: - Data
    func loadViewData() {
        guard let posterURLString = movie.posterURLString, let title = movie.title, let releaseDate = movie.releaseDate, let formattedReleaseDate = Date.new(from: releaseDate, format: "yyyy-MM-dd")?.stringWithFormat("dd/MM/yyyy"), let genresString = movie.genresString, let overview = movie.overview else { return }
        
        posterImageView.setImage(with: posterURLString, placeholderImage: UIImage.fromResource(named: .moviePlaceholder))
        titleLabel.attributedText = attributedString(with: "Title: ", text: title)
        releaseDateLabel.attributedText = attributedString(with: "Release date: ", text: formattedReleaseDate)
        genresLabel.attributedText = attributedString(with: "Genres: ", text: genresString)
        overviewTextView.text = overview
    }
    
}

// MARK: - Instantiation
extension SearchResultDetailViewController {
    
    static func instantiate(fromStoryboard storyboard: UIStoryboard) -> SearchResultDetailViewController {
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! SearchResultDetailViewController
    }
    
}

