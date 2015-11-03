//
//  TransitionAnimator.swift
//  MSTumblrMenu
//
//  Created by Maksym Shcheglov on 09/07/15.
//  Copyright (c) 2015 Maksym Shcheglov. All rights reserved.
//

import UIKit

/**
    The `MSTumblrMenuAnimationController` class implements the animations for a custom view controller transition.
*/
class MSTumblrMenuAnimationController: NSObject {

    private let kDefaultAnimationDuration = 0.5
    private let presenting: Bool

    init(presenting: Bool) {
        self.presenting = presenting
        super.init()
    }
}

extension MSTumblrMenuAnimationController: UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        guard let context = transitionContext else {
            return MSTumblrMenuCellAnimationConstants.duration
        }
        let (menuViewController, _, _) = decomposeTransitioningContext(context)
        let numberOfSections = menuViewController.numberOfSectionsInCollectionView(menuViewController.collectionView!)
        let numberOfRows = menuViewController.collectionView(menuViewController.collectionView!, numberOfItemsInSection: 0)
        return MSTumblrMenuCellAnimationConstants.delay * Double(numberOfRows * numberOfSections - 1) + MSTumblrMenuCellAnimationConstants.duration
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning)  {
        let (menuViewController, presentedControllerView, containerView) = decomposeTransitioningContext(transitionContext)

        if self.presenting {
            presentedControllerView.alpha = 0
            containerView!.addSubview(presentedControllerView)
            menuViewController.show()
        } else {
            menuViewController.hide()
        }

        let delay = self.presenting ? 0 : self.transitionDuration(transitionContext) - kDefaultAnimationDuration
        UIView.animateWithDuration(kDefaultAnimationDuration, delay: delay, options: [], animations: {
            presentedControllerView.alpha = self.presenting ? 0.9 : 0
            }) {completed in
                menuViewController.completeAnimation()
                transitionContext.completeTransition(completed)
        }
    }

    private func decomposeTransitioningContext(transitionContext: UIViewControllerContextTransitioning) -> (MSTumblrMenuViewController, UIView, UIView?) {
        let menuViewController = transitionContext.viewControllerForKey(self.presenting ? UITransitionContextToViewControllerKey : UITransitionContextFromViewControllerKey) as! MSTumblrMenuViewController
        let presentedControllerView = transitionContext.viewForKey(self.presenting ? UITransitionContextToViewKey : UITransitionContextFromViewKey)!
        let containerView = transitionContext.containerView()
        return (menuViewController, presentedControllerView, containerView)
    }

}

