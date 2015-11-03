//
//  MSTumblrMenuCellAnimation.swift
//  MSTumblrMenu
//
//  Created by Maksym Shcheglov on 23/10/15.
//  Copyright © 2015 Maksym Shcheglov. All rights reserved.
//

import UIKit

struct MSTumblrMenuCellAnimationConstants {

    static let duration: NSTimeInterval = 10
    static let damping: CGFloat = 0.8
    static let initialSpringVelocity: CGFloat = 1.0
}

/**
    The `MSTumblrMenuCellAnimation` is a class for creating animations of the menu cells.
*/
struct MSTumblrMenuCellAnimation {

    let duration = MSTumblrMenuCellAnimationConstants.duration
    let delay: Double
    let damping = MSTumblrMenuCellAnimationConstants.damping
    let initialSpringVelocity = MSTumblrMenuCellAnimationConstants.initialSpringVelocity
    let initialAction: (cell: MSTumblrMenuCell) -> Void
    let animationAction: (cell: MSTumblrMenuCell) -> Void

}
