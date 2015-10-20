//
//  MSMenuItem.swift
//  MSTumblrMenu
//
//  Created by Maksym Shcheglov on 10/07/15.
//  Copyright (c) 2015 Maksym Shcheglov. All rights reserved.
//

import UIKit

class MSTumblrMenuCell: UICollectionViewCell {

    private lazy var titleLabel: UILabel! = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .ByCharWrapping
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(18.0)
        return titleLabel
    }()
    
    private lazy var imageView: UIImageView! = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }()

    var image: UIImage? {
        get {
            return self.imageView.image
        }
        set(newImage) {
            self.imageView.image = newImage
        }
    }

    var title: String? {
        get {
            return self.titleLabel.text
        }
        set(newText) {
            self.titleLabel.text = newText
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func addAnimation(cellAnimation: MSTumblrMenuCellAnimation?) {
        guard let animation = cellAnimation else {
            return
        }
        animation.initialAction(cell: self)
        UIView.animateWithDuration(animation.duration, delay: animation.delay, usingSpringWithDamping: animation.damping, initialSpringVelocity: animation.initialSpringVelocity, options: [], animations: { animation.animationAction(cell: self) }, completion: nil)
    }

    private func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleLabel)
        self.installConstraints()
    }

    private func installConstraints() {
        let views = ["image": self.imageView, "title": self.titleLabel]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[image]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views
            ))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[title]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
        self.addConstraint(NSLayoutConstraint(item: self.imageView, attribute: .Width, relatedBy: .Equal, toItem: self.imageView, attribute: .Height, multiplier: 1.0, constant: 0.0))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[image][title]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: views))
    }


}
