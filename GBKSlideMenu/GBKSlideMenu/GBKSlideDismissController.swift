//
//  SlicerScreenViewController.swift
//  GBKSlideMenu
//
//  Created by Dmitry Popravka on 5/2/19.
//  Copyright © 2019 GBKSoft. All rights reserved.
//

import UIKit

open class GBKSlideDismissController: UIViewController {

    /// direction a slied-menu is opened
    public var direction: GBKSlideMenuDirectionType = .left
    /// menu width
    public var menuWidth: CGFloat = 0.6
    /// threshold for menu closing on `Pan Gesture`
    public var percentThreshold: CGFloat = 0.25
    /// dimming color of the current controller
    public var dimmingColor: UIColor = UIColor.lightGray.withAlphaComponent(0.35)
    /// color and shadow opacity
    public var shadow: (color: UIColor, opacity: Float) = (.lightGray ,0.5)
    /// open/close duration
    public var duration: (present: TimeInterval, dismiss: TimeInterval) = (0.35, 0.35)
    
    ///  animations
    var presentMenuAnimator: GBKSlidePresentMenuAnimation!
    var dismissMenuAnimator: GBKSlideDismissMenuAnimation!
    
    /// transitions
    var presentTransition: GBKSlidePresentTransition?
    let dismissTransition: GBKSlideDismissTransition = {
        let dismiss = GBKSlideDismissTransition()
        dismiss.completionCurve = .easeInOut
        return dismiss
    } ()
    
    //MARK: -
    //MARK: init
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInit()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!)  {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupInit()
    }
    
    private func setupInit() {
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
        
        presentMenuAnimator = GBKSlidePresentMenuAnimation()
        presentMenuAnimator.delegate = self
        
        dismissMenuAnimator = GBKSlideDismissMenuAnimation()
    }

    //MARK: -
    //MARK: dismiss
    
    override open func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        dismissTransition.finish()
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension GBKSlideDismissController: UIViewControllerTransitioningDelegate {
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return GBKSlidePresentation(presentedViewController: presented, presenting: presenting)
    }
    
    public func animationController(forPresented forPresentedController: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentMenuAnimator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissMenuAnimator
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return dismissTransition
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return presentTransition
    }
}

// MARK: - GBKSlidePresentMenuAnimationDelegate
extension GBKSlideDismissController: GBKSlidePresentMenuAnimationDelegate {
    
    func slidePresent(menu: GBKSlidePresentMenuAnimation, tapGesture sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    func slidePresent(menu: GBKSlidePresentMenuAnimation, handleGesture sender: UIPanGestureRecognizer) {

        if dismissTransition.activePanGesture != nil && dismissTransition.activePanGesture != sender {
            return
        }
        
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .began:

            dismissTransition.activePanGesture = sender
            dismissTransition.shouldFinish = false
            dismissTransition.completionSpeed = GBKSlideMenuConstant.gestureCompletionSpeed
            super.dismiss(animated: true, completion: nil)
            
        case .changed:
            
            let progress = dismissTransition.calculateProgress(translationInView: translation,
                                                               viewBounds: view.bounds,
                                                               menuWidth: menuWidth,
                                                               direction: direction)
            
            dismissTransition.shouldFinish = progress > percentThreshold
            dismissTransition.update(progress)
            
        case .ended:
            dismissTransition.completionSpeed = 1
            dismissTransition.shouldFinish ? dismissTransition.finish() : dismissTransition.cancel()
            dismissTransition.shouldFinish = true
            dismissTransition.activePanGesture = nil
            
        default:
            dismissTransition.completionSpeed = 1
            dismissTransition.cancel()
            dismissTransition.shouldFinish = true
            dismissTransition.activePanGesture = nil
        }
    }
}
