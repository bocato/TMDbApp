//
//  SplashViewController.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGenres()
    }
    
    // MARK: - Layout
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - API Calls
    func loadGenres() {
        self.activityIndicator.startAnimating()
        GenresService().getGenres(onSuccess: { (movieGenres, serviceResponse) in
            ApplicationData.shared.movieGenres = movieGenres
            NavigationRouter().perform(segue: .home)
        }, onFailure: { (serviceResponse) in
            let bottomAlertController = BottomAlertController.instantiateNew(withTitle: "Error", text: "An unexpected error ocurred.", leftButtonTitle: "Cancel", leftButtonActionClosure: nil, rightButtonTitle: "Retry", rightButtonActionClosure: {
                self.loadGenres()
            })
            self.present(bottomAlertController, animated: true, completion: nil)
        }, onCompletion: {
            self.activityIndicator.stopAnimating()
        })
    }
}

extension SplashViewController {
    
    // MARK: - Instantiation
    static func instantiate(fromStoryboard storyboard: UIStoryboard) -> SplashViewController {
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! SplashViewController
    }
    
}
