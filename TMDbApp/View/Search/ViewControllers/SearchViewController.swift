//
//  SearchViewController.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit
import Kingfisher

fileprivate enum ViewState {
    case noSearch
    case loading
    case noResults
    case serviceSuccess
}

fileprivate struct ViewDefaults {
    static let defaultSearchCellHeight = CGFloat(120)
    static let searchFirstLoadCellIdentifier = "SearchFirstLoadTableViewCell"
    static let emptySearchCellIdentifier = "EmptySearchTableViewCell"
    static let searchResultTableViewCellSkeletonIdentifier = "SearchResultTableViewCellSkeleton"
    static let navigationControllerNavigationBarFrameKeyPath = "navigationController.navigationBar.frame"
}

class SearchViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    // MARK: - Properties
    fileprivate var searchResponse: SearchResponse?
    fileprivate var searchResults: [Movie]?
    fileprivate var viewState: ViewState = .noSearch {
        didSet {
            DispatchQueue.main.async {
                if self.viewState == .serviceSuccess {
                    self.tableView.addSubview(self.refreshControl)
                } else {
                    self.refreshControl.removeFromSuperview()
                }
                self.configureTableViewForViewState()
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
    }
    fileprivate var searchTerm: String?
    fileprivate var refreshControl: UIRefreshControl = ({
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.lightGray
        refreshControl.addTarget(self, action: #selector(SearchViewController.reloadViewData), for: .valueChanged)
        return refreshControl
    })()
    fileprivate var isObservingnavigationControllerNavigationBarFrameKeyPath = false
    
    // MARK: - Computed Properties
    fileprivate var searchController: UISearchController = ({
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by movie name"
        return searchController
    })()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureObservers()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    deinit {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        if isObservingnavigationControllerNavigationBarFrameKeyPath {
            removeObserver(self, forKeyPath: ViewDefaults.navigationControllerNavigationBarFrameKeyPath)
        }
    }
    
    // MARK: - Configuration
    func configureTableViewForViewState() {
        self.tableView.isScrollEnabled = self.viewState == .serviceSuccess
        self.tableView.separatorStyle = self.viewState == .serviceSuccess ? .singleLine : .none
        self.tableView.separatorColor = self.viewState == .serviceSuccess ? UIColor.lightGray : UIColor.clear
    }
    
    func configureViewElements() {
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func configureObservers() {
        addObserver(self, forKeyPath: ViewDefaults.navigationControllerNavigationBarFrameKeyPath, options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        isObservingnavigationControllerNavigationBarFrameKeyPath = true
    }
    
    // MARK: - Observers
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == ViewDefaults.navigationControllerNavigationBarFrameKeyPath { // this makes the cell have the right size and stay centered
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
    }
    
    // MARK: - Helpers
    func resetView() {
        searchTerm = nil
        searchResponse = nil
        searchResults = nil
        viewState = .noSearch
        searchController.searchBar.text = ""
    }
    
    // MARK: - API Calls
    func performBasicSearch() {
        performSearch(with: searchTerm) { (searchResponse, serviceResponse) in
            self.searchResponse = searchResponse
            self.searchResults = searchResponse?.results
            if let _ = searchResponse, let searchResults = self.searchResults, searchResults.count > 0 {
                self.viewState = .serviceSuccess
            } else {
                self.searchResponse = nil
                self.searchResults = nil
                self.viewState = .noResults
            }
        }
    }
    
    func fetchSearchResults(forPage page: Int!) {
        performSearch(with: searchTerm, page: page) { (searchResponse, serviceResponse) in
            guard let searchResponse = searchResponse, let currentSearchResults = self.searchResults else { return }
            self.searchResponse = searchResponse
            if let searchResults = searchResponse.results, searchResults.count > 0 && !currentSearchResults.elementsEqual(searchResults) {
                let resultsPlusNextPage = currentSearchResults + searchResults
                self.searchResults = resultsPlusNextPage
                self.viewState = .serviceSuccess
            }
        }
    }
    
    func performSearch(with searchTerm: String!, page: Int = 1, success: @escaping ((_ searchResponse: SearchResponse?, _ serviceResponse: ServiceResponse?) -> Void)){
        viewState = .loading
        SearchService().findMovie(by: searchTerm, page: page, success: { (searchResponse, serviceResponse) in
            success(searchResponse, serviceResponse)
        }, onFailure: { (serviceResponse) in
            self.viewState = .noResults
            self.searchController.dismiss(animated: false, completion: nil)
            let message = serviceResponse?.serviceError?.statusMessage ?? ErrorMessage.unexpected.rawValue
            let bottomAlertController = BottomAlertController.instantiateNew(withTitle: "Error", text: message, leftButtonTitle: "Cancel", leftButtonActionClosure: {
                debugPrint("Cancel touched.")
            }, rightButtonTitle: "Retry", rightButtonActionClosure: {
                self.performBasicSearch()
            })
            self.tabBarController?.present(bottomAlertController, animated: true, completion: nil)
        }, onCompletion: {
            self.refreshControl.endRefreshing()
        })
    }
    
    @objc func reloadViewData(){
        if viewState == .serviceSuccess {
            performBasicSearch()
        }
    }
    
    // MARK: - Actions
    func addThisMovieToFavorites(_ movie: Movie!){
        if let dictionary = movie.dictionaryValueForRealm {
            let realmMovie = RealmMovie(value: dictionary as Any)
            FavoriteMoviesDatabaseManager.shared.addOrUpdate(realmMovie: realmMovie, onSuccess: {
                let bottomAlertController = BottomAlertController.instantiateNew(withTitle: "Great!", text: "You added \(movie.title ?? "a movie") to your favorites!", buttonTitle: "Ok", actionClosure: nil)
                self.tabBarController?.present(bottomAlertController, animated: true, completion: nil)
            }, onFailure: { _ in
                let bottomAlertController = BottomAlertController.instantiateNew(withTitle: "Oops!", text: "Could not add \(movie.title ?? "a movie") to your favorites! \nCheck if it is not already there.", buttonTitle: "Ok", actionClosure: nil)
                self.tabBarController?.present(bottomAlertController, animated: true, completion: nil)
            })
        } else {
            let bottomAlertController = BottomAlertController.instantiateNew(withTitle: "Oops!", text: "Could not add \(movie.title ?? "a movie") to your favorites!", buttonTitle: "Ok", actionClosure: nil)
            self.tabBarController?.present(bottomAlertController, animated: true, completion: nil)
        }
    }
    
    func removeThisMovieFromFavorites(_ movie: Movie!){
        FavoriteMoviesDatabaseManager.shared.deleteMovie(with: movie.id!, onSuccess: {
            let bottomAlertController = BottomAlertController.instantiateNew(withTitle: "Great!", text: "You removed \(movie.title ?? "a movie") from your favorites!", buttonTitle: "Ok", actionClosure: nil)
            self.tabBarController?.present(bottomAlertController, animated: true, completion: nil)
        }, onFailure: { _ in
            let bottomAlertController = BottomAlertController.instantiateNew(withTitle: "Oops!", text: "Could not remove \(movie.title ?? "a movie") from your favorites! \nIt's was probably never there.", buttonTitle: "Ok", actionClosure: nil)
            self.tabBarController?.present(bottomAlertController, animated: true, completion: nil)
        })
    }
    
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTerm = searchBar.text ?? ""
        searchBar.resignFirstResponder()
        performBasicSearch()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetView()
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            resetView()
            searchBar.resignFirstResponder()
        }
    }
    
}

// MARK: - SkeletonTableViewDataSource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewState {
        case .noSearch:
            return 1
        case .loading:
            return Int(floor(Float(tableView.bounds.size.height)/Float(ViewDefaults.defaultSearchCellHeight))) + 1
        case .serviceSuccess:
            guard let numberOfRowsInSection = searchResults?.count else {
                viewState = .noResults
                return 1
            }
            return numberOfRowsInSection
        case .noResults:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewState {
        case .noSearch:
            return tableView.dequeueReusableCell(withIdentifier: ViewDefaults.searchFirstLoadCellIdentifier, for: indexPath)
        case .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: ViewDefaults.searchResultTableViewCellSkeletonIdentifier, for: indexPath)
            return cell
        case .serviceSuccess:
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as! SearchResultTableViewCell
            if let searchResults = searchResults, indexPath.row < searchResults.count {
                cell.configure(with: searchResults[indexPath.row])
            }
            return cell
        case .noResults:
            return tableView.dequeueReusableCell(withIdentifier: ViewDefaults.emptySearchCellIdentifier, for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let movie = searchResults?[indexPath.row] else { return nil }
        var actions = [UITableViewRowAction]()
        if !ApplicationData.isThisMovieAFavorite(movie) {
            let addToFavoritesAction = UITableViewRowAction(style: .default, title: "Add to Favorites", handler: { (action, indexPath) in
                self.addThisMovieToFavorites(movie)
            })
            addToFavoritesAction.backgroundColor = UIColor(from: "#3366ff")
            actions.append(addToFavoritesAction)
        } else {
            let removeFromFavoritesAction = UITableViewRowAction(style: .default, title: "Remove from Favorites", handler: { (action, indexPath) in
                self.removeThisMovieFromFavorites(movie)
            })
            removeFromFavoritesAction.backgroundColor = UIColor.red
            actions.append(removeFromFavoritesAction)
        }
        return actions
    }
    
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewState == .noSearch || viewState == .noResults {
            return tableView.frame.size.height
        }
        return ViewDefaults.defaultSearchCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewState == .serviceSuccess {
            guard let movie = self.searchResults?[indexPath.row] else { return }
            NavigationRouter().perform(segue: .searchResultDetail, from: self, info: movie, completion: nil)
        } else if viewState == .noSearch || viewState == .noResults {
            DispatchQueue.main.async {
                self.searchController.searchBar.endEditing(true)
                self.searchController.searchBar.resignFirstResponder()
            }
        }
    }
    
}

// MARK: - UISCrollViewDelegate
extension SearchViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if viewState == .serviceSuccess && tableView.scrollDidReachBottom {
            guard let currentPage = searchResponse?.page, let totalPages = searchResponse?.totalPages, currentPage+1 <= totalPages else { return }
            fetchSearchResults(forPage: currentPage + 1)
        }
    }
    
}

// MARK: - Instantiation
extension SearchViewController {
    
    static func instantiate(fromStoryboard storyboard: UIStoryboard) -> SearchViewController {
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! SearchViewController
    }
    
}
