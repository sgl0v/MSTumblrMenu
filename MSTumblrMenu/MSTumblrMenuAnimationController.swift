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
        return 2
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning)  {
        let menuViewController = transitionContext.viewControllerForKey(self.presenting ? UITransitionContextToViewControllerKey : UITransitionContextFromViewControllerKey) as! MSTumblrMenuViewController
        let presentedControllerView = transitionContext.viewForKey(self.presenting ? UITransitionContextToViewKey : UITransitionContextFromViewKey)!
        let containerView = transitionContext.containerView()

        if self.presenting {
            presentedControllerView.alpha = 0
            containerView!.addSubview(presentedControllerView)
            menuViewController.show()
        } else {
            menuViewController.hide()
        }

        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
            presentedControllerView.alpha = self.presenting ? 0.7 : 0
            }) {completed in
                menuViewController.completeAnimation()
                transitionContext.completeTransition(completed)
        }
    }

}

