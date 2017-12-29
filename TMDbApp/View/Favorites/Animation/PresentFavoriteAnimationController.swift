//
//  PresentFavoriteAnimationController.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 29/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

class PresentFavoriteAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: Properties
    var animatedTransitionStartPointFrame: CGRect = .zero
    
    // MARK: - UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.15
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard let _ = transitionContext.viewController(forKey: .from) as? FavoritesViewController,
            let toViewController = transitionContext.viewController(forKey: .to) as? SearchResultDetailViewController else {
                return
        }
        
        containerView.addSubview(toViewController.view)
        toViewController.positionContainer(left: 20.0,
                                           right: 20.0,
                                           top: animatedTransitionStartPointFrame.origin.y + 20.0,
                                           bottom: 0.0)
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            toViewController.positionContainer(left: 0.0,
                                               right: 0.0,
                                               top: 0.0,
                                               bottom: 0.0)
            toViewController.view.backgroundColor = .white
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}
