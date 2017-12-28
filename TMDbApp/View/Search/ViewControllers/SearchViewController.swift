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
    case serviceEmpty
    case serviceSuccess
}

fileprivate struct ViewDefaults {
    static let defaultSearchCellHeight = CGFloat(120)
    static let searchFirstLoadCellIdentifier = "SearchFirstLoadTableViewCell"
}

class SearchViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    // MARK: - Properties
    fileprivate var searchResults: [Movie]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
    }
    fileprivate var viewState: ViewState = .noSearch {
        didSet {
            self.tableView.isScrollEnabled = viewState == .serviceSuccess
        }
    }
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - Configuration
    func configureViewElements() {
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchTerm = searchBar.text ?? ""
        searchBar.resignFirstResponder()
        viewState = .loading
        SearchService().findMovie(by: searchTerm, success: { (searchResponse, serviceResponse) in
            self.searchResults = searchResponse?.results
            if let _ = self.searchResults, self.searchResults!.count > 0 {
                self.viewState = .serviceSuccess
            } else {
                self.viewState = .serviceEmpty
            }
        }, onFailure: { (serviceResponse) in
            debugPrint("Failure")
        }, onCompletion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults = nil
        viewState = .noSearch
        searchBar.text = ""
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
        case .serviceEmpty:
            return 1
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdenfierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return SearchResultTableViewCell.identifier
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewState {
        case .noSearch:
            let cell = tableView.dequeueReusableCell(withIdentifier: ViewDefaults.searchFirstLoadCellIdentifier, for: indexPath)
            cell.hideSkeleton()
            cell.layoutSubviews()
            return cell
        case .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as! SearchResultTableViewCell
            cell.showSkeleton()
            return cell
        case .serviceSuccess:
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as! SearchResultTableViewCell
            cell.configure(with: searchResults?[indexPath.row])
            cell.hideSkeleton()
            return cell
        case .serviceEmpty:
            // TODO: Create empty cell
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as! SearchResultTableViewCell
             cell.hideSkeleton()
            return cell
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
        if viewState == .noSearch || viewState == .serviceEmpty {
            return tableView.bounds.size.height
        }
        return ViewDefaults.defaultSearchCellHeight
    }
    
}

// MARK: - Instantiation
extension SearchViewController {
    
    static func instantiate(fromStoryboard storyboard: UIStoryboard) -> SearchViewController {
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! SearchViewController
    }
    
}
