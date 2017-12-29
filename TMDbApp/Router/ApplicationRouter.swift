//
//  ApplicationRouter.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

/* NOTE:
 Since this application is not a big one (yet), we have only one router...
 When the application grows, it is usefull to implement other routers in order to
 to achieve better organization an cleaner code (businesse logic, routing, etc).
 */
class ApplicationRouter {
    
    // MARK: Singleton
    static let instance = ApplicationRouter()
    
    // MARK: - ApplicationStartPoint Enum
    fileprivate enum ApplicationStartPoint {
        case splash
        case search
        case favorites
    }
    
    // MARK: - Properties
    fileprivate var window: UIWindow!
    fileprivate var root: ApplicationStartPoint! = .splash
    
    // MARK: - Lazy Properties
    fileprivate lazy var splashStoryboard: UIStoryboard = UIStoryboard(name: "Splash", bundle: nil)
    fileprivate lazy var tabBarStoryboard: UIStoryboard = UIStoryboard(name: "TabBar", bundle: nil)
    
    // MARK: Computed Properties
    var topViewController: UIViewController? {
        guard let rootViewController = window.rootViewController else { return nil }
        if rootViewController.isKind(of: TabBarViewController.self) {
            let tabBarViewController = rootViewController as! UITabBarController
            return tabBarViewController.viewControllers?[tabBarViewController.selectedIndex]
        } else {
            return rootViewController
        }
    }
    var topNavigationController: UINavigationController? {
        guard let rootViewController = window.rootViewController else { return nil }
        if rootViewController.isKind(of: TabBarViewController.self) {
            return topViewController?.navigationController
        } else {
            return rootViewController as? UINavigationController
        }
    }
    
    // MARK: - Lifecycle
    func startApplication(in window: UIWindow?) {
        guard let window = window else { return }
        self.window = window
        self.startApplication(in: window, startPoint: .splash)
    }
    
    fileprivate func startApplication(in window: UIWindow, startPoint: ApplicationStartPoint) {
        root = startPoint
        switch startPoint {
        case .splash:
            let splashViewController = SplashViewController.instantiate(fromStoryboard: splashStoryboard)
            setRootViewController(splashViewController, for: window)
            return
        case .search:
            let tabBarViewController = TabBarViewController.instantiate(fromStoryboard: tabBarStoryboard)
            tabBarViewController.setSelectedTab(.search)
            setRootViewController(tabBarViewController, for: window)
            return
        case .favorites:
            let tabBarViewController = TabBarViewController.instantiate(fromStoryboard: tabBarStoryboard)
            tabBarViewController.setSelectedTab(.favorites)
            setRootViewController(tabBarViewController, for: window)
            return
        }
    }
    
    fileprivate func setRootViewController(_ rootViewController: UIViewController, for window: UIWindow) {
        DispatchQueue.main.async {
            UIView.transition(with: window, duration: 5.0, options: [.curveEaseIn] , animations: {
                window.rootViewController = rootViewController
                window.makeKeyAndVisible()
            }, completion: nil)
        }
    }
    
    func setTabBarAsRoot() {
        startApplication(in: window, startPoint: .search)
    }
    
}
