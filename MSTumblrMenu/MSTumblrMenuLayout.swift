//
//  MSTumblrMenuLayout.swift
//  MSTumblrMenu
//
//  Created by Maksym Shcheglov on 13/07/15.
//  Copyright (c) 2015 Maksym Shcheglov. All rights reserved.
//

import UIKit

/**
    The `MSTumblrMenuLayout` instance provides layout information for a tumblr menu.
*/
class MSTumblrMenuLayout: UICollectionViewLayout {

    var itemSize: CGSize
    var itemSpacing: CGFloat
    private var indexPathsToAnimate = [NSIndexPath]()
    private var layoutAttributes: [NSIndexPath: UICollectionViewLayoutAttributes]!

    init(itemSize: CGSize = CGSizeMake(100, 120), itemSpacing: CGFloat = 15.0) {
        self.itemSize = itemSize
        self.itemSpacing = itemSpacing
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareLayout() {
        super.prepareLayout()
        self.layoutAttributes = self.generateLayoutAttributes()
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.layoutAttributes.map({ (_, attributes) -> UICollectionViewLayoutAttributes in
            return attributes
        }).filter { attributes -> Bool in
            return CGRectIntersectsRect(attributes.frame, rect)
        }
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return self.layoutAttributes[indexPath]
    }

    override func collectionViewContentSize() -> CGSize {
        if let collectionView = self.collectionView {
            return collectionView.bounds.size
        } else {
            return CGSizeZero
        }
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    // MARK: Private

    private func generateLayoutAttributes() -> [NSIndexPath: UICollectionViewLayoutAttributes] {
        var layoutAttributes = [NSIndexPath: UICollectionViewLayoutAttributes]()
        let height = self.collectionViewContentSize().height
        let width = self.collectionViewContentSize().width
        let numberOfSections = self.collectionView!.numberOfSections()
        let offsetY = (height - CGFloat(numberOfSections) * (self.itemSize.height + self.itemSpacing) + self.itemSpacing) / 2
        for section in 0..<numberOfSections {
            let numberOfItems = self.collectionView!.numberOfItemsInSection(section)
            let offsetX = (width - CGFloat(numberOfItems) * self.itemSize.width - CGFloat(numberOfItems - 1) * self.itemSpacing) / 2
            for row in 0..<numberOfItems {
                let indexPath = NSIndexPath(forRow: row, inSection: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.size = self.itemSize
                attributes.center = CGPointMake(offsetX + CGFloat(indexPath.row) * (self.itemSize.width + self.itemSpacing) + self.itemSize.width / 2, offsetY + CGFloat(indexPath.section) * (self.itemSize.height + self.itemSpacing) + self.itemSize.height / 2)
                layoutAttributes[indexPath] = attributes
            }
        }
        return layoutAttributes
    }

}
