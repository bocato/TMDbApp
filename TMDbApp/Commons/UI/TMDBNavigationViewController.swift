//
//  TMDBNavigationViewController.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

class TMDBNavigationViewController: UINavigationController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - UI
    func configureUI() {
        self.navigationBar.prefersLargeTitles = true
    }

}
