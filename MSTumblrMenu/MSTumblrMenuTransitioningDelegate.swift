//
//  TransitionManager.swift
//  MSTumblrMenu
//
//  Created by Maksym Shcheglov on 09/07/15.
//  Copyright (c) 2015 Maksym Shcheglov. All rights reserved.
//

import UIKit

class MSTumblrMenuTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

//    private var animationController: UIViewControllerAnimatedTransitioning
//
//    init(animationController: UIViewControllerAnimatedTransitioning) {
//        self.animationController = animationController
//        super.init()
//    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MSTumblrMenuAnimationController(presenting: true)
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MSTumblrMenuAnimationController(presenting: false)
    }
}
