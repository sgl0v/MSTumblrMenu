//
//  MSMenuItem.swift
//  MSTumblrMenu
//
//  Created by Maksym Shcheglov on 10/07/15.
//  Copyright (c) 2015 Maksym Shcheglov. All rights reserved.
//

import UIKit

class MSTumblrMenuCell: UICollectionViewCell {

    private var title: UILabel!
    private var icon: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.greenColor()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.greenColor()
    }

    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        if let menuCellLayoutAttributes = layoutAttributes as? MSTumblrMenuLayoutAttributes, animation = menuCellLayoutAttributes.animation {
            self.layer.addAnimation(animation, forKey: "position")
        }
    }

}
