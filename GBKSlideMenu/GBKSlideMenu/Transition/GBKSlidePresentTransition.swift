//
//  GBKSlideMenuTransition1.swift
//  GBKSlideMenu
//
//  Created by Dmitry Popravka on 5/11/19.
//  Copyright © 2019 GBKSoft. All rights reserved.
//

import UIKit

/// An object that drives an interactive animation between one view controller and another.
class GBKSlidePresentTransition: UIPercentDrivenInteractiveTransition {
    
    var hasStarted = false
    var shouldFinish = false
    
    /// calculate the progress of the animation
    func progress(translationInView: CGPoint,
                  viewBounds: CGRect,
                  menuWidth: CGFloat,
                  direction: GBKSlideMenuDirectionType) -> CGFloat {
        
        var movementOnAxis: Float {
            switch direction {
            case .top:
                return Float(translationInView.y / (viewBounds.height * menuWidth))
            case .bottom:
                return -Float(translationInView.y / (viewBounds.height * menuWidth))
            case .right:
                return -Float(translationInView.x / (viewBounds.width * menuWidth))
            case .left:
                return Float(translationInView.x / (viewBounds.width * menuWidth))
            }
        }
        
        let positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
        let positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
        return CGFloat(positiveMovementOnAxisPercent)
    }
    
}
