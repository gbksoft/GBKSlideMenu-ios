//
//  GBKSlideDismissMenuAnimation.swift
//  GBKSlideMenu
//
//  Created by Dmitry Popravka on 5/5/19.
//  Copyright © 2019 GBKSoft. All rights reserved.
//

import UIKit

/// A set of methods for implementing the dismiss animations.
class GBKSlideDismissMenuAnimation: UIViewController, UIViewControllerAnimatedTransitioning {

    /// Asks your animator object for the duration (in seconds) of the transition animation.
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        let minDurationInterval = GBKSlideMenuConstant.minDurationInterval
        
        guard let controller = transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.from) as? GBKSlideDismissController else {
            return minDurationInterval
        }
        
        return controller.duration.dismiss < minDurationInterval ? minDurationInterval : controller.duration.dismiss
    }
    
    /// Tells your animator object to perform the transition animations.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? GBKSlideDismissController else {
            return
        }
        
        let blackout = transitionContext.containerView.viewWithTag(GBKSlideMenuConstant.dimmingTag)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: {
                        
                        blackout?.alpha = 0
                        
                        switch fromController.direction {
                        case .top:
                            fromController.view!.frame.origin.y -= UIScreen.main.bounds.height * fromController.menuWidth
                        case .bottom:
                            fromController.view!.frame.origin.y += UIScreen.main.bounds.height * fromController.menuWidth
                        case .left:
                            fromController.view!.frame.origin.x -= UIScreen.main.bounds.width * fromController.menuWidth
                        case .right:
                            fromController.view!.frame.origin.x += UIScreen.main.bounds.width * fromController.menuWidth
                        }
                        
        }, completion: { _ in
                        
                        let didTransitionComplete = !transitionContext.transitionWasCancelled
                        
                        if didTransitionComplete {
                            blackout?.removeFromSuperview()
                        }
                        
                        transitionContext.completeTransition(didTransitionComplete)
        })
    }
}
