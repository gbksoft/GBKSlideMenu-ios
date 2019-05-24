//
//  GBKSlidePresenterController.swift
//  GBKSlideMenu
//
//  Created by Dmitry Popravka on 5/13/19.
//  Copyright © 2019 GBKSoft. All rights reserved.
//

import UIKit

open class GBKSlidePresenterController: UIViewController {
    
    /// block, which describes the logic of initialization of GBKSlideDismissController
    public var initGestureSlideController: (() -> GBKSlideDismissController)? {
        didSet {
            if initGestureSlideController != nil && slidePanGesture == nil {
                slidePanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)) )
                slidePanGesture!.minimumNumberOfTouches = 1
                view.addGestureRecognizer(slidePanGesture!)
            } else if initGestureSlideController == nil && slidePanGesture != nil {
                view.removeGestureRecognizer(slidePanGesture!)
                slidePanGesture = nil
            }
        }
    }

    /// GBKSlideDismissController, which opens with gesture
    private weak var slideController: GBKSlideDismissController?

    /// pan gesture to open slide menu
    private var slidePanGesture: UIPanGestureRecognizer?

    //MARK: -
    //MARK: gesture
    
    @objc private func handleGesture(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: gesture.view)
        
        switch gesture.state {
        case .began:
            
            if slideController?.presentTransition?.hasStarted ?? false {
                slideController?.presentTransition?.completionSpeed = 1
                return
            }
            
            guard let controller = initGestureSlideController?() else {
                return
            }
            
            let transition: GBKSlidePresentTransition = {
                let dismiss = GBKSlidePresentTransition()
                dismiss.shouldFinish = false
                dismiss.completionSpeed = GBKSlideMenuConstant.gestureCompletionSpeed
                dismiss.completionCurve = .easeInOut
                return dismiss
            } ()
            
            controller.presentTransition = transition
            
            slideController = controller
            
            present(controller, animated: true, completion: nil)

        case .changed:
            
            guard let controller = slideController,
                  let transition = controller.presentTransition else {
                return
            }
            
            let progress = transition.progress(translationInView: translation,
                                                viewBounds: view.bounds,
                                                menuWidth: controller.menuWidth,
                                                direction: controller.direction)
            
            transition.shouldFinish = progress > controller.percentThreshold
            transition.update(progress)
            
        case .ended:
            
            guard let transition = slideController?.presentTransition else {
                return
            }
            
            transition.completionSpeed = 1
            transition.shouldFinish ? transition.finish() : transition.cancel()
            transition.shouldFinish = false
            slideController = nil
            
        default:
            
            guard let transition = slideController?.presentTransition else {
                return
            }
            
            transition.shouldFinish = false
            transition.completionSpeed = 1
            transition.cancel()
            slideController = nil
        }
    }
}
