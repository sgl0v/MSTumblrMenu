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

    var image: UIImage? {
        get {
            return self.icon.image
        }
        set(newImage) {
            self.icon.image = newImage
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.icon = UIImageView()
        self.icon.translatesAutoresizingMaskIntoConstraints = false
        self.icon.contentMode = .ScaleAspectFit
        self.contentView.addSubview(self.icon)
        let views = ["icon": self.icon]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[icon]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views
            ))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[icon]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
    }

    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        if let menuCellLayoutAttributes = layoutAttributes as? MSTumblrMenuLayoutAttributes, animation = menuCellLayoutAttributes.animation {
            self.layer.addAnimation(animation, forKey: "position")
        }
    }

}
