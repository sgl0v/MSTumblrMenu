//
//  MSTumblrMenuFlowLayout.swift
//  MSTumblrMenu
//
//  Created by Maksym Shcheglov on 13/07/15.
//  Copyright (c) 2015 Maksym Shcheglov. All rights reserved.
//

import UIKit

class MSTumblrMenuFlowLayout: UICollectionViewLayout {

    let cellSize = CGSizeMake(100, 100)
    let cellSpace: CGFloat = 30.0
    var indexPathsToAnimate : Array<NSIndexPath>!
    var cachedAttributes = [NSIndexPath: MSTumblrMenuLayoutAttributes]()

    override func prepareLayout() {
        super.prepareLayout()
        cachedAttributes.removeAll(keepCapacity: false)
        for section in 0..<self.collectionView!.numberOfSections() {
            for item in 0..<self.collectionView!.numberOfItemsInSection(section) {
                let indexPath = NSIndexPath(forItem: item, inSection: section)
                let attributes = MSTumblrMenuLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.size = self.cellSize
                attributes.center = CGPointMake(CGFloat(indexPath.row) * (cellSize.width + cellSpace) + cellSize.width / 2, 200 + CGFloat(indexPath.section) * (cellSize.height + cellSpace) + cellSize.height / 2)
                cachedAttributes[indexPath] = attributes
            }
        }
    }

    override class func layoutAttributesClass() -> AnyClass {
        return MSTumblrMenuLayoutAttributes.self
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var result = [UICollectionViewLayoutAttributes]()
        for (_, attributes) in cachedAttributes {
            if CGRectIntersectsRect(attributes.frame, rect) {
                result.append(attributes)
            }
        }
        return result
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
        var offset = self.collectionViewContentSize().height + 300 * CGFloat(itemIndexPath.section) * CGFloat((self.collectionView!.numberOfItemsInSection(itemIndexPath.section)))
        if itemIndexPath.row == 0 {
            offset += 300
        } else if itemIndexPath.row == 2 {
            offset += 600
        }
        var delay = 0.1 * Double(itemIndexPath.section) * Double((self.collectionView!.numberOfItemsInSection(itemIndexPath.section)))
        if itemIndexPath.row == 0 {
            delay += 0.1
        } else if itemIndexPath.row == 2 {
            delay += 0.1 * 2
        }


        let transformAnimation = CABasicAnimation(keyPath: "position.y")
        transformAnimation.duration = 0.3
        transformAnimation.fromValue = offset + CGFloat(itemIndexPath.section) * (cellSize.height + cellSpace)
        transformAnimation.toValue = 200 + CGFloat(itemIndexPath.section) * (cellSize.height + cellSpace)
        transformAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.45, 1.2, 0.75, 1.0)
        transformAnimation.removedOnCompletion = false
        transformAnimation.fillMode = kCAFillModeForwards
        transformAnimation.beginTime = CACurrentMediaTime() + delay

        let attributes = MSTumblrMenuLayoutAttributes(forCellWithIndexPath: itemIndexPath)
        attributes.animation = transformAnimation
        attributes.size = self.cellSize
        attributes.center = CGPointMake(CGFloat(itemIndexPath.row) * (cellSize.width + cellSpace),  offset + CGFloat(itemIndexPath.section) * (cellSize.height + cellSpace))
        return attributes
    }

    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        super.prepareForCollectionViewUpdates(updateItems)
        self.indexPathsToAnimate = [NSIndexPath]()
        for updateItem in updateItems {
            let updateAction = updateItem.updateAction
            if updateAction == .Insert {
                let indexPath = (updateItem as UICollectionViewUpdateItem).indexPathAfterUpdate
                self.indexPathsToAnimate.append(indexPath)
            }
        }
    }

    override func finalizeCollectionViewUpdates() {
        self.indexPathsToAnimate = nil
    }


//    var layoutAttributes = Array<Array<UICollectionViewLayoutAttributes>>()
//
//
//    override func collectionViewContentSize() -> CGSize {
//        return self.collectionView!.contentSize
//    }
//
//    override func prepareLayout() {
//        layoutAttributes.removeAll(keepCapacity: false)
//        let width: CGFloat = CGRectGetWidth(self.collectionView!.bounds)
//        let numberOfSections = self.collectionView!.dataSource!.numberOfSectionsInCollectionView!(self.collectionView!)
//        for section in 0..<numberOfSections {
//            let numberOfItems: CGFloat = CGFloat(self.collectionView!.dataSource!.collectionView(self.collectionView!, numberOfItemsInSection: section))
//            let cellWidth = (width - (numberOfItems + 1) * 20.0) / numberOfItems
//            let cellIndexPath = NSIndexPath()
//            let cellLayoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: cellIndexPath)
//            layoutAttributes.append(cellLayoutAttributes)
//        }
//    }
//
//    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
//        var tmp = [UICollectionViewLayoutAttributes]()
//        for sectionAttributes in layoutAttributes {
//            tmp.extend(filter(sectionAttributes, { cellAttributes -> Bool in
//                return CGRectIntersectsRect(rect, cellAttributes.frame)
//            }))
//        }
//        return tmp
//    }
//
//    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
//        return self.layoutAttributes[indexPath.section][indexPath.row]
//    }

//    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
//        return false
//    }

    // MARK: Private
}
