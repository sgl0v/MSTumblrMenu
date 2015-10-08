//
//  MSTumblrMenuLayout.swift
//  MSTumblrMenu
//
//  Created by Maksym Shcheglov on 13/07/15.
//  Copyright (c) 2015 Maksym Shcheglov. All rights reserved.
//

import UIKit

class MSTumblrMenuLayout: UICollectionViewLayout {

    var cellSize = CGSizeMake(100, 120)
    let cellSpace: CGFloat = 20.0
    private var indexPathsToAnimate = [NSIndexPath]()
    private var layoutAttributes: [NSIndexPath: UICollectionViewLayoutAttributes]!

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
        let minY = (height - CGFloat(numberOfSections) * (self.cellSize.height + self.cellSpace) + self.cellSpace) / 2
        for section in 0..<numberOfSections {
            let numberOfItems = self.collectionView!.numberOfItemsInSection(section)
            let minX = (width - CGFloat(numberOfItems) * (self.cellSize.width + self.cellSpace) + self.cellSpace) / 2
            for row in 0..<numberOfItems {
                let indexPath = NSIndexPath(forRow: row, inSection: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.size = self.cellSize
                attributes.center = CGPointMake(minX + CGFloat(indexPath.row) * (self.cellSize.width + self.cellSpace) + self.cellSize.width / 2, minY + CGFloat(indexPath.section) * (self.cellSize.height + self.cellSpace) + self.cellSize.height / 2)
                layoutAttributes[indexPath] = attributes
            }
        }
        return layoutAttributes
    }

}
