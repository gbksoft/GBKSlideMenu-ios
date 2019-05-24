//
//  GBKSlideDismissMenuPresentation.swift
//  GBKSlideMenu
//
//  Created by Dmitry Popravka on 5/22/19.
//  Copyright © 2019 GBKSoft. All rights reserved.
//

import UIKit

/// An object that manages the transition animations and the presentation of view controllers onscreen.
class GBKSlidePresentation: UIPresentationController {
    
    /// Adding a custom view during a presentation
    override func presentationTransitionWillBegin() {
        self.containerView!.addSubview(self.presentedView!)
    }

}
