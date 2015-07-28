//
//  MSTumblrMenuLayoutAttributes.swift
//  MSTumblrMenu
//
//  Created by Maksym Shcheglov on 28/07/15.
//  Copyright (c) 2015 Maksym Shcheglov. All rights reserved.
//

import UIKit

class MSTumblrMenuLayoutAttributes: UICollectionViewLayoutAttributes {

    var animation: CABasicAnimation?

    override func copyWithZone(zone: NSZone) -> AnyObject {
        let tumblrMenuLayoutAttributes = super.copyWithZone(zone) as! MSTumblrMenuLayoutAttributes
        tumblrMenuLayoutAttributes.animation = animation
        return tumblrMenuLayoutAttributes
    }

}

