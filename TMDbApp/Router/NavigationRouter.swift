//
//  NavigationRouter.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

/* NOTE:
 Since this application is not a big enough, we have only one router...
 When the application grows, it is usefull to implement other routers in order to
 to achieve better organization an cleaner code (businesse logic, routing, etc).
 */
class NavigationRouter {
    
    // MARK: Segue Enum
    public enum Segue {
        case home
        case searchResultDetail
    }
    
    // MARK: - Storyboards
    fileprivate lazy var searchStoryboard: UIStoryboard = UIStoryboard(name: "Search", bundle: nil)
    
    
    // MARK: - Navigation Methods
    private func move(from: UIViewController!, to: UIViewController!, transition: TransitionType!, animation: Any? = nil, completion: (()->Void)? = nil) {
        switch transition {
        case .push:
            from.navigationController?.pushViewController(to, animated: true)
        case .present:
            from.present(to, animated: true, completion: completion)
        default:
            return
        }
    }
    
    func perform(segue: Segue!, from: UIViewController? = nil, info: Any? = nil, animation: Any? = nil, completion: (()->Void)? = nil) {
        switch segue {
        case .home:
            ApplicationRouter.instance.setTabBarAsRoot()
            return
        case .searchResultDetail:
            let searchResultDetailViewController = SearchResultDetailViewController.instantiate(fromStoryboard: searchStoryboard)
            searchResultDetailViewController.movie = info as! Movie
            move(from: from, to: searchResultDetailViewController, transition: .push, animation: nil, completion: nil)
            return
        default:
            return
        }
    }
    
}
