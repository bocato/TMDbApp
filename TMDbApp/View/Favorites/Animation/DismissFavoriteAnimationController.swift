//
//  DismissFavoriteAnimationController.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 29/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

class DismissFavoriteAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: Properties
    var animatedTransitionStartPointFrame: CGRect = .zero
    
    // MARK: - UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.15
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? SearchResultDetailViewController,
            let toViewController = transitionContext.viewController(forKey: .to) as? FavoritesViewController else {
                return
        }
        
        toViewController.view.isHidden = true
        containerView.addSubview(toViewController.view)
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            fromViewController.positionContainer(left: 20.0,
                                                 right: 20.0,
                                                 top: self.animatedTransitionStartPointFrame.origin.y + 20.0,
                                                 bottom: 0.0)
        }) { (_) in
            toViewController.view.isHidden = false
            fromViewController.view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
}
