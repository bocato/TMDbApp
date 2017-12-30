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
    var animatedTransitionStartPoint: CGPoint = .zero
    
    // MARK: - UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? SearchResultDetailViewController,
            let toViewController = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        toViewController.view.alpha = 0
        containerView.addSubview(toViewController.view)
        
        let duration = transitionDuration(using: transitionContext)
        let left: CGFloat = 20.0
        let right: CGFloat = 20.0
        let top: CGFloat = 20.0
        let bottom: CGFloat = self.animatedTransitionStartPoint.y
        UIView.animate(withDuration: duration, animations: {
            fromViewController.positionContainer(left: left,
                                                 right: right,
                                                 top: top,
                                                 bottom: bottom)
        }) { (_) in
            toViewController.view.alpha = 1
            fromViewController.view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
}
