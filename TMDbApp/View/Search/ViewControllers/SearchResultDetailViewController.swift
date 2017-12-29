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
    static let similarMoviesTableViewCellHeight: CGFloat = 250
}

class SearchResultDetailViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var tableViewHeader: UIView!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Constants
    let titleAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.black]
    let textAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.darkGray]
    
    // MARK: Properties
    var movie: Movie!
    fileprivate var similarMoviesResponse: SearchResponse?
    fileprivate var similarMovies: [Movie]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            }
        }
    }
    
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
        loadMovieData()
        loadSimilarMoviesFirstPage()
    }
    
    func loadMovieData() {
        guard let backdropPathURLString = movie.backdropPathURLString, let title = movie.title, let releaseDate = movie.releaseDate, let formattedReleaseDate = Date.new(from: releaseDate, format: "yyyy-MM-dd")?.stringWithFormat("dd/MM/yyyy"), let genresString = movie.genresString else { return }
        backdropImageView.setImage(with: backdropPathURLString, placeholderImage: UIImage.fromResource(named: .moviePlaceholder))
        titleLabel.attributedText = attributedString(with: "Title: ", text: title)
        releaseDateLabel.attributedText = attributedString(with: "Release date: ", text: formattedReleaseDate)
        genresLabel.attributedText = attributedString(with: "Genres: ", text: genresString)
    }
    
    // MARK: - API Calls
    func loadSimilarMoviesFirstPage() {
//        view.startLoading(.whiteLarge, tintColor: .amethyst, backgroundColor: UIColor.white)
        fetchSimilarMovies(success: { (response, serviceResponse) in
            self.similarMoviesResponse = response
            self.similarMovies = response?.results
        }, completion: {
//            self.view.stopLoading()
        })
    }

//    func fetchSimilarMovies(forPage page: Int!, completion: (() -> Void)? = nil) {
//        fetchSimilarMovies(success: { (response, serviceResponse) in
//            guard let response = response, let currentSimilarMovies = self.similarMovies else { return }
//            self.similarMoviesResponse = response
//            if let similarMoviesResponseResults = response.results, similarMoviesResponseResults.count > 0 {
//                let resultsPlusNextPage = currentSimilarMovies + similarMoviesResponseResults
//                self.similarMovies = resultsPlusNextPage
//            }
//        }, completion: {
//            completion?()
//        })
//    }
    
    func fetchSimilarMovies(forPage page: Int = 1, success: @escaping ((_ searchResponse: SearchResponse?, _ serviceResponse: ServiceResponse?) -> Void), completion: (() -> Void)? = nil){
        guard let movieId = movie.id else { return }
        MoviesService().getSimilarMovies(for: movieId, page: page, success: { (response, serviceResponse) in
            success(response, serviceResponse)
        }, onFailure:  { (serviceResponse) in
            let message = serviceResponse?.serviceError?.statusMessage ?? "An unexpected error ocurred."
            let bottomAlertController = BottomAlertController.instantiateNew(withTitle: "Error", text: message, leftButtonTitle: "Cancel", leftButtonActionClosure: {
                self.navigationController?.popViewController(animated: true)
            }, rightButtonTitle: "Retry", rightButtonActionClosure: {
                self.loadSimilarMoviesFirstPage()
            })
            self.tabBarController?.present(bottomAlertController, animated: true, completion: nil)
        }, onCompletion: {
            completion?()
        })
    }
    
}

// MARK: - UITableViewDataSource
extension SearchResultDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let similarMovies = similarMovies else { return 1 }
        return similarMovies.count > 0 ? 2 : 1
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
            let cell = tableView.dequeueReusableCell(withIdentifier: SimilarMoviesTableViewCell.identifier, for: indexPath) as! SimilarMoviesTableViewCell
            cell.dataSource = self
            cell.delegate = self
            return cell
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
            return "Similar Movies"
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
            return ViewDefaults.similarMoviesTableViewCellHeight
        default: // We won't get here...
            return 0
        }
    }
    
}

// MARK: - SimilarMoviesTableViewCellDataSource
extension SearchResultDetailViewController: SimilarMoviesTableViewCellDataSource {
    
    func similarMoviesTableViewCell(_ similarMoviesTableViewCell: SimilarMoviesTableViewCell, collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let similarMovies = similarMovies else { return 0 }
        return similarMovies.count
    }
    
    func similarMoviesTableViewCell(_ similarMoviesTableViewCell: SimilarMoviesTableViewCell, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarMovieCollectionViewCell.identifier, for: indexPath) as! SimilarMovieCollectionViewCell
        cell.configure(with: similarMovies?[indexPath.row])
        return cell
    }
    
}

// MARK: - SimilarMoviesTableViewCellDelegate
extension SearchResultDetailViewController: SimilarMoviesTableViewCellDelegate {
    
    func similarMoviesTableViewCell(_ similarMoviesTableViewCell: SimilarMoviesTableViewCell, collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("similarMoviesTableViewCell:collectionView:didSelectItemAt")
    }
    
    func similarMoviesTableViewCell(_ similarMoviesTableViewCell: SimilarMoviesTableViewCell, collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? SimilarMovieCollectionViewCell)?.cancelDownloadTask()
    }
    
    func similarMoviesTableViewCellScrollViewDidScroll(_ similarMoviesTableViewCell: SimilarMoviesTableViewCell, collectionView: UICollectionView, scrollView: UIScrollView) {
        debugPrint("similarMoviesTableViewCellScrollViewDidScroll:collectionView:scrollView")
    }
    
}


// MARK: - Instantiation
extension SearchResultDetailViewController {
    
    static func instantiate(fromStoryboard storyboard: UIStoryboard) -> SearchResultDetailViewController {
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! SearchResultDetailViewController
    }
    
}

