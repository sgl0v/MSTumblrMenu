//
//  TransitionAnimator.swift
//  MSTumblrMenu
//
//  Created by Maksym Shcheglov on 09/07/15.
//  Copyright (c) 2015 Maksym Shcheglov. All rights reserved.
//

import UIKit

class MSTumblrMenuAnimationController: NSObject {

    private let presenting: Bool

    init(presenting: Bool) {
        self.presenting = presenting
        super.init()
    }
}

extension MSTumblrMenuAnimationController: UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning)  {
        let menuViewController = transitionContext.viewControllerForKey(self.presenting ? UITransitionContextToViewControllerKey : UITransitionContextFromViewControllerKey) as! MSTumblrMenuViewController
        let presentedControllerView = transitionContext.viewForKey(self.presenting ? UITransitionContextToViewKey : UITransitionContextFromViewKey)!
        let containerView = transitionContext.containerView()

        if self.presenting {
            presentedControllerView.alpha = 0
            containerView!.addSubview(presentedControllerView)
            menuViewController.addItems()
        } else {
            menuViewController.removeItems()
        }

        UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .AllowUserInteraction, animations: {
            presentedControllerView.alpha = self.presenting ? 0.7 : 0
            }, completion: {(completed: Bool) -> Void in
                transitionContext.completeTransition(completed)
        })
    }

}

