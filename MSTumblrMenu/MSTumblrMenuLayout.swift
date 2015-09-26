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
    let rowsCount = 3
    private var indexPathsToAnimate : Array<NSIndexPath>!
    var cachedAttributes = [NSIndexPath: MSTumblrMenuLayoutAttributes]()

    override func prepareLayout() {
        super.prepareLayout()
        self.cachedAttributes = [NSIndexPath: MSTumblrMenuLayoutAttributes]()
        let height = self.collectionViewContentSize().height
        let width = self.collectionViewContentSize().width
        let numberOfSections = self.collectionView!.numberOfSections()
        let minY = (height - CGFloat(numberOfSections) * (self.cellSize.height + self.cellSpace) + self.cellSpace) / 2
        for section in 0..<numberOfSections {
            let numberOfItems = self.collectionView!.numberOfItemsInSection(section)
            let minX = (width - CGFloat(rowsCount) * (self.cellSize.width + self.cellSpace) + self.cellSpace) / 2
            for row in 0..<numberOfItems {
                let indexPath = NSIndexPath(forRow: row, inSection: section)
                let attributes = MSTumblrMenuLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.size = self.cellSize
                attributes.center = CGPointMake(minX + CGFloat(indexPath.row) * (self.cellSize.width + self.cellSpace) + self.cellSize.width / 2, minY + CGFloat(indexPath.section) * (self.cellSize.height + self.cellSpace) + self.cellSize.height / 2)
                self.cachedAttributes[indexPath] = attributes
            }
        }
    }

    override class func layoutAttributesClass() -> AnyClass {
        return MSTumblrMenuLayoutAttributes.self
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.cachedAttributes.map({ (_, attributes) -> UICollectionViewLayoutAttributes in
            return attributes
        }).filter { attributes -> Bool in
            return CGRectIntersectsRect(attributes.frame, rect)
        }
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cachedAttributes[indexPath]
    }

    override func collectionViewContentSize() -> CGSize {
        if let collectionView = self.collectionView {
            return collectionView.bounds.size
        } else {
            return CGSizeZero
        }
    }

    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        if self.indexPathsToAnimate.indexOf(itemIndexPath) == nil {
            return super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
        }
        let offset = self.collectionViewContentSize().height
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: itemIndexPath)
//        attributes.alpha = 1.0
        attributes.size = self.cellSize
        attributes.center = CGPointMake(self.cachedAttributes[itemIndexPath]!.center.x,  offset + self.cachedAttributes[itemIndexPath]!.center.y)
        return attributes
    }


    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        if self.indexPathsToAnimate.indexOf(itemIndexPath) == nil {
            return super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)
        }
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: itemIndexPath)
//        attributes.alpha = 1.0
        attributes.size = self.cellSize
        attributes.center = CGPointMake(CGFloat(itemIndexPath.row) * (cellSize.width + cellSpace) + cellSize.width / 2,  -cellSize.height / 2)
        return attributes
    }

    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        super.prepareForCollectionViewUpdates(updateItems)
        self.indexPathsToAnimate = [NSIndexPath]()
        for updateItem in updateItems {
            if (updateItem.updateAction == .Insert) {
                self.indexPathsToAnimate.append((updateItem as UICollectionViewUpdateItem).indexPathAfterUpdate)
            } else if (updateItem.updateAction == .Delete) {
                self.indexPathsToAnimate.append((updateItem as UICollectionViewUpdateItem).indexPathBeforeUpdate)
            }
        }
    }

    override func finalizeCollectionViewUpdates() {
        self.indexPathsToAnimate = [NSIndexPath]()
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    // MARK: Private
}
