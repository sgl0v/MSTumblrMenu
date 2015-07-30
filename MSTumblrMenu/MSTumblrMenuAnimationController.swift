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
        let presentedControllerView = self.presenting ? transitionContext.viewForKey(UITransitionContextToViewKey)! : transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let containerView = transitionContext.containerView()

        if self.presenting {
            presentedControllerView.alpha = 0
            containerView!.addSubview(presentedControllerView)
            let menuViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! MSTumblrMenuViewController
            menuViewController.addItems()
        }

        UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .AllowUserInteraction, animations: {
            presentedControllerView.alpha = self.presenting ? 0.5 : 0
            }, completion: {(completed: Bool) -> Void in
                transitionContext.completeTransition(completed)
        })
    }

}

