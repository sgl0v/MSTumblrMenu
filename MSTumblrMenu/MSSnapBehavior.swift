//
//  MSSnapBehavior.swift
//  MSTumblrMenu
//
//  Created by Maksym Shcheglov on 27/07/15.
//  Copyright (c) 2015 Maksym Shcheglov. All rights reserved.
//

import UIKit

class MSSnapBehavior: UIDynamicBehavior {

    private let item: UIDynamicItem
    private let snapToPoint: CGPoint
    private var startingTime: NSDate?
    
    init(view: UIView, item: UIDynamicItem, snapToPoint: CGPoint) {
        self.item = item
        self.snapToPoint = snapToPoint
        super.init()
        let fakeView = UIView(frame: CGRectMake(0, 0, 10, 10))
        view.addSubview(fakeView)
        let clockMandate = UIGravityBehavior(items: [item])
        self.addChildBehavior(clockMandate)

        self.action = {
            NSLog("called!")
            if self.startingTime == nil {
                self.startingTime = NSDate()
            }
            let time = NSDate().timeIntervalSinceDate(self.startingTime!)
            NSLog("called %.2f", time)
            if time > 2.5 {
                self.removeChildBehavior(clockMandate)
                fakeView.removeFromSuperview()
            }
        }
    }
}
