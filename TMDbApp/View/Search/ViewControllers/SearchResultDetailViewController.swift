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
    @IBOutlet private  weak var contentContainerView: UIView!
    @IBOutlet private weak var contentContainerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentContainerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentContainerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableViewHeader: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet private weak var backdropImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Constants
    let titleAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.black]
    let textAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.darkGray]
    
    // MARK: Properties
    var movie: Movie!
    fileprivate var similarMoviesResponse: SearchResponse?
    fileprivate var similarMovies: [Movie]?
    fileprivate var isFetchingSimilarMovies = false
    fileprivate var controllerToPresentAlerts: UIViewController? {
        return self.tabBarController ?? ApplicationRouter.instance.topNavigationController ?? ApplicationRouter.instance.topViewController
    }
    var hideDismissButton = true
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dismissButton.isHidden = hideDismissButton
    }
    
    // MARK: - Configuration
    func positionContainer(left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat) {
        contentContainerViewLeadingConstraint.constant = left
        contentContainerViewTrailingConstraint.constant = right
        contentContainerViewTopConstraint.constant = top
        contentContainerViewBottomConstraint.constant = bottom
        view.layoutIfNeeded()
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
        tableView.setAndLayoutTableHeaderView(header: tableViewHeader)
    }
    
    // MARK: - API Calls
    func loadSimilarMoviesFirstPage() {
        SwiftyLoadingView.show(in: view, withText: "", background: false, activityIndicatorStyle: .whiteLarge, activityIndicatorColor: UIColor.blue)
        fetchSimilarMovies(success: { (response, serviceResponse) in
            self.similarMoviesResponse = response
            self.similarMovies = response?.results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }, completion: {
            SwiftyLoadingView.hide(for: self.view)
        })
    }

    func fetchSimilarMovies(forPage page: Int = 1, success: @escaping ((_ searchResponse: SearchResponse?, _ serviceResponse: ServiceResponse?) -> Void), completion: (() -> Void)? = nil){
        guard let movieId = movie.id else { return }
        self.isFetchingSimilarMovies = true
        MoviesService().getSimilarMovies(for: movieId, page: page, success: { (response, serviceResponse) in
            self.isFetchingSimilarMovies = false
            success(response, serviceResponse)
        }, onFailure:  { (serviceResponse) in
            self.isFetchingSimilarMovies = false
            let message = serviceResponse?.serviceError?.statusMessage ?? "An unexpected error ocurred."
            let bottomAlertController = BottomAlertController.instantiateNew(withTitle: "Error", text: message, leftButtonTitle: "Cancel", leftButtonActionClosure: {
                self.navigationController?.popViewController(animated: true)
            }, rightButtonTitle: "Retry", rightButtonActionClosure: {
                self.loadSimilarMoviesFirstPage()
            })
            self.controllerToPresentAlerts?.present(bottomAlertController, animated: true, completion: nil)
        }, onCompletion: {
            completion?()
        })
    }
    
    // MARK: - Actions
    func addThisMovieToFavorites(){
        if ApplicationData.shared.addToFavorites(self.movie) {
            let bottomAlertController = BottomAlertController.instantiateNew(withTitle: "Great!", text: "You added \(self.movie.title ?? "a movie") to your favorites!", buttonTitle: "Ok", actionClosure: nil)
            self.tabBarController?.present(bottomAlertController, animated: true, completion: nil)
        } else {
            let bottomAlertController = BottomAlertController.instantiateNew(withTitle: "Oops!", text: "Could not add \(self.movie.title ?? "a movie") to your favorites! \nCheck if it is not already there.", buttonTitle: "Ok", actionClosure: nil)
            self.controllerToPresentAlerts?.present(bottomAlertController, animated: true, completion: nil)
        }
    }
    
    func removeThisMovieFromFavorites(){
        if ApplicationData.shared.removeFromFavorites(self.movie) {
            let bottomAlertController = BottomAlertController.instantiateNew(withTitle: "Great!", text: "You removed \(self.movie.title ?? "a movie") from your favorites!", buttonTitle: "Ok", actionClosure: nil)
            self.tabBarController?.present(bottomAlertController, animated: true, completion: nil)
        } else {
            let bottomAlertController = BottomAlertController.instantiateNew(withTitle: "Oops!", text: "Could not remove \(self.movie.title ?? "a movie") from your favorites! \nIt's was probably never there.", buttonTitle: "Ok", actionClosure: nil)
            self.controllerToPresentAlerts?.present(bottomAlertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - IBActions
    @IBAction func dismissButtonDidReceiveTouchUpInside(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
                    self.controllerToPresentAlerts?.present(photosViewController, animated: true, completion: nil)
                }
            }, addToFavoritesButtonActionClosure: { cell in
                if ApplicationData.shared.isThisMovieAFavorite(self.movie) {
                    self.removeThisMovieFromFavorites()
                } else {
                    self.addThisMovieToFavorites()
                }
                cell.configureFavoriteButton(for: self.movie)
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
        if let movie = similarMovies?[indexPath.row] {
            NavigationRouter().perform(segue: .similarMovieDetails, from: self, info: movie, completion: nil)
        }
    }
    
    func similarMoviesTableViewCell(_ similarMoviesTableViewCell: SimilarMoviesTableViewCell, collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? SimilarMovieCollectionViewCell)?.cancelDownloadTask()
    }
    
    func similarMoviesTableViewCellScrollViewDidScroll(_ similarMoviesTableViewCell: SimilarMoviesTableViewCell, collectionView: UICollectionView, scrollView: UIScrollView) {
        if let similarMovies = similarMovies, similarMovies.count > 0, collectionView.scrollDidReachRightEdge {
            guard let currentPage = similarMoviesResponse?.page, let totalPages = similarMoviesResponse?.totalPages, currentPage+1 <= totalPages, !self.isFetchingSimilarMovies else { return }
            fetchSimilarMovies(forPage: currentPage + 1, success: { (response, serviceResponse) in
                guard let response = response, let currentSimilarMovies = self.similarMovies else { return }
                self.similarMoviesResponse = response
                if let similarMoviesResponseResults = response.results, similarMoviesResponseResults.count > 0 && !currentSimilarMovies.elementsEqual(similarMoviesResponseResults)  {
                    let resultsPlusNextPage = currentSimilarMovies + similarMoviesResponseResults
                    self.similarMovies = resultsPlusNextPage
                    DispatchQueue.main.async {
                        collectionView.reloadData()
                    }
                }
            })
        }
    }
    
}


// MARK: - Instantiation
extension SearchResultDetailViewController {
    
    static func instantiate(fromStoryboard storyboard: UIStoryboard) -> SearchResultDetailViewController {
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! SearchResultDetailViewController
    }
    
}

