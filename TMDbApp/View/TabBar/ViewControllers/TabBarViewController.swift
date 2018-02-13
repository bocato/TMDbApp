//
//  TabBarViewController.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    // MARk: - Enum
    enum TabIndex {
        case favorites
        case search
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Configuration
    func configureUI(){
        navigationController?.isNavigationBarHidden = false
        tabBar.isTranslucent = true
    }
    
    // MARK: - Helpers
    func setSelectedTab(_ tabIndex: TabIndex!) {
        selectedIndex = tabIndex.hashValue
    }
    
}

extension TabBarViewController {
    
    // MARK: - Instantiation
    static func instantiate(fromStoryboard storyboard: UIStoryboard) -> TabBarViewController {
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! TabBarViewController
    }
    
}
