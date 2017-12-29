//
//  SearchResultDetailViewController.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 29/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit
import NYTPhotoViewer

fileprivate enum TableViewSection {
    case overview
    case similar
}

fileprivate struct ViewDefaults {
    static let overviewTableViewCellHeight: CGFloat = 250
    static let similarTableViewCellHeight: CGFloat = 250
}

class SearchResultDetailViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var tableViewHeader: UIView!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    
    // MARK: Constants
    let titleAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.black]
    let textAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.darkGray]
    
    // MARK: Properties
    var movie: Movie!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewElements()
        loadViewData()
    }
    
    // MARK: - Configuration
    func configureViewElements() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.title = "Details"
    }
    
    // MARK: - Helpers
    func attributedString(with title: String!, text: String!) ->  NSAttributedString{
        let attributedString = NSMutableAttributedString(string: title, attributes: titleAttributes)
        attributedString.append(NSAttributedString(string: text, attributes: textAttributes))
        return attributedString
    }
    
    // MARK: - Data
    func loadViewData() {
        guard let backdropPathURLString = movie.backdropPathURLString, let title = movie.title, let releaseDate = movie.releaseDate, let formattedReleaseDate = Date.new(from: releaseDate, format: "yyyy-MM-dd")?.stringWithFormat("dd/MM/yyyy"), let genresString = movie.genresString else { return }
        backdropImageView.setImage(with: backdropPathURLString, placeholderImage: UIImage.fromResource(named: .moviePlaceholder))
        titleLabel.attributedText = attributedString(with: "Title: ", text: title)
        releaseDateLabel.attributedText = attributedString(with: "Release date: ", text: formattedReleaseDate)
        genresLabel.attributedText = attributedString(with: "Genres: ", text: genresString)
    }
    
}

// MARK: - UITableViewDataSource
extension SearchResultDetailViewController: UITableViewDataSource {
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case TableViewSection.overview.hashValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: OverViewTableViewCell.identifier, for: indexPath) as! OverViewTableViewCell
            cell.configure(with: movie, posterImageViewTapActionClosure: { (cell) in
                if let image = cell.posterImageView.image {
                    let photos = [Photo(image: image)]
                    let photosViewController = NYTPhotosViewController(photos: photos)
                    self.tabBarController?.present(photosViewController, animated: true, completion: nil)
                }
            }, addToFavoritesButtonActionClosure: { _ in
                debugPrint("addToFavoritesButtonActionClosure")
            })
            return cell
        case TableViewSection.similar.hashValue:
//            let cell = tableView.dequeueReusableCell(withIdentifier: similarTableViewCell.identifier, for: indexPath)
            return UITableViewCell()
        default: // We won't get here...
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case TableViewSection.overview.hashValue:
            (cell as? OverViewTableViewCell)?.cancelDownloadTask()
        default: // We won't get here...
            return
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case TableViewSection.overview.hashValue:
            return "Overview"
        case TableViewSection.similar.hashValue:
            return "similar"
        default:
            return nil
        }
    }
    
}

// MARK: - UITableViewDelegate
extension SearchResultDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case TableViewSection.overview.hashValue:
            return ViewDefaults.overviewTableViewCellHeight
        case TableViewSection.similar.hashValue:
            return ViewDefaults.similarTableViewCellHeight
        default: // We won't get here...
            return 0
        }
    }
    
}

// MARK: - Instantiation
extension SearchResultDetailViewController {
    
    static func instantiate(fromStoryboard storyboard: UIStoryboard) -> SearchResultDetailViewController {
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! SearchResultDetailViewController
    }
    
}

