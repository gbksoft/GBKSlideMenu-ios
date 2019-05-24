//
//  GBKSlidePresentMenuAnimation.swift
//  GBKSlideMenu
//
//  Created by Dmitry Popravka on 5/5/19.
//  Copyright © 2019 GBKSoft. All rights reserved.
//

import UIKit

/// delegate, for tracking gestures.
protocol GBKSlidePresentMenuAnimationDelegate: class {
    
    /// UIPanGestureRecognizer
    func slidePresent(menu: GBKSlidePresentMenuAnimation,
                      handleGesture sender: UIPanGestureRecognizer)
    
    /// UITapGestureRecognizer
    func slidePresent(menu: GBKSlidePresentMenuAnimation,
                      tapGesture sender: UITapGestureRecognizer)
}

/// A set of methods for implementing the present animations.
class GBKSlidePresentMenuAnimation: UIViewController, UIViewControllerAnimatedTransitioning {
    
    private var toPanGesture: UIPanGestureRecognizer!
    private var dimmingPanGesture: UIPanGestureRecognizer!
    private var tapGesture: UITapGestureRecognizer!
    
    weak var delegate: GBKSlidePresentMenuAnimationDelegate?
    
    /// Asks your animator object for the duration (in seconds) of the transition animation.
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        let minDurationInterval = GBKSlideMenuConstant.minDurationInterval
        
        guard let controller = transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.to) as? GBKSlideDismissController else {
            return minDurationInterval
        }
        
        return controller.duration.present < minDurationInterval ? minDurationInterval : controller.duration.present
    }
    
    /// Tells your animator object to perform the transition animations.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
              let toController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? GBKSlideDismissController else {
                  return
        }
        
        let containerView = transitionContext.containerView
        // blackout View
        let dimmingView = initDimmingView(containerView: containerView, toController: toController)
        // toController
        toPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(sender:)))
        toPanGesture.maximumNumberOfTouches = 1
        toController.view!.addGestureRecognizer(toPanGesture)
        containerView.insertSubview(toController.view, aboveSubview: fromController.view)
        // toController shadow
        toController.view.layer.masksToBounds = false
        toController.view.layer.shadowOpacity = toController.shadow.opacity
        toController.view.layer.shadowColor = toController.shadow.color.cgColor
        // direction
        switch toController.direction {
        case .top:
            toController.view.layer.shadowOffset = CGSize(width: 0, height: 5)
        case .bottom:
            toController.view.layer.shadowOffset = CGSize(width: 0, height: -5)
        case .left:
            toController.view.layer.shadowOffset = CGSize(width: 5, height: 0)
        case .right:
            toController.view.layer.shadowOffset = CGSize(width: -5, height: 0)
        }
        // first toController location
        switch toController.direction {
        case .top:
            toController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleTopMargin]
            toController.view!.frame.origin.y = -toController.view!.frame.height
        case .bottom:
            toController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleTopMargin]
            toController.view!.frame.origin.y = toController.view!.frame.height
        case .left:
            toController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin, .flexibleRightMargin]
            toController.view!.frame.origin.x = -toController.view!.frame.width
        case .right:
            toController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin]
            toController.view!.frame.origin.x = toController.view!.frame.width
        }
        /// animation
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: {
                        
                        dimmingView.alpha = 1
                        
                        switch toController.direction {
                        case .top:
                            toController.view!.frame.origin.y += UIScreen.main.bounds.height * toController.menuWidth
                        case .bottom:
                            toController.view!.frame.origin.y -= UIScreen.main.bounds.height * toController.menuWidth
                        case .left:
                            toController.view!.frame.origin.x += UIScreen.main.bounds.width * toController.menuWidth
                        case .right:
                            toController.view!.frame.origin.x -= UIScreen.main.bounds.width * toController.menuWidth
                        }
                        
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    //MARK: -
    //MARK: dimmingView
    
    private func initDimmingView(containerView: UIView, toController: GBKSlideDismissController) -> UIView {
        
        let dimming = UIView(frame: containerView.frame)
        dimming.tag = GBKSlideMenuConstant.dimmingTag
        
        dimming.backgroundColor = toController.dimmingColor
        dimming.alpha = 0
        dimming.isUserInteractionEnabled = true
        
        dimmingPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(sender:)))
        dimmingPanGesture.maximumNumberOfTouches = 1
        dimming.addGestureRecognizer(dimmingPanGesture)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        dimming.addGestureRecognizer(tapGesture)
        
        containerView.insertSubview(dimming, belowSubview: toController.view)

        dimming.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin]
        
        return dimming
    }
    
    //MARK: -
    //MARK: gesture selector
    
    @objc private func handleGesture(sender: UIPanGestureRecognizer) {
        delegate?.slidePresent(menu: self, handleGesture: sender)
    }
    
    @objc private func tapGesture(sender: UITapGestureRecognizer) {
        delegate?.slidePresent(menu: self, tapGesture: sender)
    }
    
}
