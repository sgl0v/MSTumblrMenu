//
//  TransitionAnimator.swift
//  MSTumblrMenu
//
//  Created by Maksym Shcheglov on 09/07/15.
//  Copyright (c) 2015 Maksym Shcheglov. All rights reserved.
//

import UIKit

class MSTumblrMenuAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    private let presenting: Bool
    private var minOffset: CGFloat {
        return CGRectGetHeight(UIScreen.mainScreen().bounds) / 3
    }
    private var maxOffset: CGFloat {
        return self.minOffset * 2
    }

    init(presenting: Bool) {
        self.presenting = presenting
        super.init()
    }

    private func prepareForPresentingViewController(menuViewController: MSTumblrMenuViewController) {
        menuViewController.view.alpha = 0.0

        menuViewController.menuItem1.transform = CGAffineTransformMakeTranslation(0.0, maxOffset)
        menuViewController.menuItem2.transform = CGAffineTransformMakeTranslation(0.0, minOffset)
        menuViewController.menuItem3.transform = CGAffineTransformMakeTranslation(0.0, maxOffset)
    }

    private func presentViewController(menuViewController: MSTumblrMenuViewController) {
        menuViewController.view.alpha = 1.0

        menuViewController.menuItem1.transform = CGAffineTransformIdentity
        menuViewController.menuItem2.transform = CGAffineTransformIdentity
        menuViewController.menuItem3.transform = CGAffineTransformIdentity
    }

    private func dismissViewController(menuViewController: MSTumblrMenuViewController) {
        menuViewController.view.alpha = 0.0

        menuViewController.menuItem1.transform = CGAffineTransformMakeTranslation(0.0, -minOffset)
        menuViewController.menuItem2.transform = CGAffineTransformMakeTranslation(0.0, -maxOffset)
        menuViewController.menuItem3.transform = CGAffineTransformMakeTranslation(0.0, -minOffset)
    }

}

extension MSTumblrMenuAnimationController: UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.6
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()
        let controllers : (from: UIViewController, to: UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)

        let menuViewController = self.presenting ? controllers.to as! MSTumblrMenuViewController : controllers.from as! MSTumblrMenuViewController
        let bottomViewController = self.presenting ? controllers.from : controllers.to

        container.addSubview(bottomViewController.view)
        container.addSubview(menuViewController.view)
        if self.presenting {
            self.prepareForPresentingViewController(menuViewController)
        }

        let duration = self.transitionDuration(transitionContext)

        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: nil, animations: { () -> Void in
            if self.presenting {
                self.presentViewController(menuViewController)
            } else {
                self.dismissViewController(menuViewController)
            }
            }) { finished in
                transitionContext.completeTransition(true)
        }
    }
}

