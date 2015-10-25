//
//  TransitionManager.swift
//  MSTumblrMenu
//
//  Created by Maksym Shcheglov on 09/07/15.
//  Copyright (c) 2015 Maksym Shcheglov. All rights reserved.
//

import UIKit

/**
    The `MSTumblrMenuTransitioningDelegate` class implements interactive transition between view controllers.
*/
class MSTumblrMenuTransitioningDelegate : NSObject, UIViewControllerTransitioningDelegate {

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MSTumblrMenuAnimationController(presenting: true)
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MSTumblrMenuAnimationController(presenting: false)
    }

}
