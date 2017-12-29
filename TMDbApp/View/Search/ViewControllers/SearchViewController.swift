//
//  SearchViewController.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit
import SkeletonView
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
}

class SearchViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    // MARK: - Properties
    fileprivate var searchResponse: SearchResponse?
    fileprivate var searchResults: [Movie]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
    }
    fileprivate var viewState: ViewState = .noSearch {
        didSet {
            DispatchQueue.main.async {
                self.tableView.isScrollEnabled = self.viewState == .serviceSuccess
                self.tableView.separatorColor = self.viewState == .serviceSuccess ? UIColor.lightGray : UIColor.clear
            }
        }
    }
    fileprivate var searchTerm: String?
    
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
        configureObservers()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    deinit {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        removeObserver(self, forKeyPath: "navigationController.navigationBar.frame")
    }
    
    // MARK: - Configuration
    func configureViewElements() {
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func configureObservers() {
        addObserver(self, forKeyPath: "navigationController.navigationBar.frame", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
    }
    
    // MARK: - Observers
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "navigationController.navigationBar.frame" { // this makes the cell have the right size and stay centered
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
            if let _ = self.searchResults, self.searchResults!.count > 0 {
                self.viewState = .serviceSuccess
            } else {
                self.viewState = .noResults
            }
        }
    }
    
    func fetchSearchResults(forPage page: Int!) {
        performSearch(with: searchTerm, page: page) { (searchResponse, serviceResponse) in
            guard let searchResponse = searchResponse, let currentSearchResults = self.searchResults else { return }
            self.searchResponse = searchResponse
            if let searchResults = searchResponse.results, searchResults.count > 0 {
                self.viewState = .serviceSuccess
                let resultsPlusNextPage = currentSearchResults + searchResults
                self.searchResults = resultsPlusNextPage
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
//            let message = serviceResponse?.serviceError?.statusMessage ?? "An unexpected error ocurred."
//            let bottomAlertController = BottomAlertController.instantiateNew(withTitle: "Error", text: message, leftButtonTitle: "Cancel", leftButtonActionClosure: nil, rightButtonTitle: "Retry", rightButtonActionClosure: {
//                self.performSearch(with: searchTerm)
//            })
//            self.tabBarController?.present(bottomAlertController, animated: true, completion: nil)
        }, onCompletion: nil)
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
    
}

// MARK: - SkeletonTableViewDataSource
extension SearchViewController: SkeletonTableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewState {
        case .noSearch:
            return 1
        case .loading:
            return Int(floor(Float(tableView.bounds.size.height)/Float(ViewDefaults.defaultSearchCellHeight)))
        case .serviceSuccess:
            return searchResults!.count
        case .noResults:
            return 1
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdenfierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return SearchResultTableViewCell.identifier
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewState {
        case .noSearch:
            return tableView.dequeueReusableCell(withIdentifier: ViewDefaults.searchFirstLoadCellIdentifier, for: indexPath)
        case .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as! SearchResultTableViewCell
            if searchResponse!.page == 1 {
                cell.showSkeleton()
            }
            return cell
        case .serviceSuccess:
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as! SearchResultTableViewCell
            cell.configure(with: searchResults?[indexPath.row])
            cell.hideSkeleton()
            return cell
        case .noResults:
            return tableView.dequeueReusableCell(withIdentifier: ViewDefaults.emptySearchCellIdentifier, for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? SearchResultTableViewCell else { return }
        cell.cancelDownloadTask()
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
        guard let movie = self.searchResults?[indexPath.row] else { return }
        NavigationRouter().perform(segue: .searchResultDetail, from: self, info: movie, animation: nil, completion: nil)
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
