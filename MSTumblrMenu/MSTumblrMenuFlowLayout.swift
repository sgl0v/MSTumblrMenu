//
//  MSTumblrMenuFlowLayout.swift
//  MSTumblrMenu
//
//  Created by Maksym Shcheglov on 13/07/15.
//  Copyright (c) 2015 Maksym Shcheglov. All rights reserved.
//

import UIKit

class MSTumblrMenuFlowLayout: UICollectionViewLayout {

    var dynamicAnimator: UIDynamicAnimator!
    var collisionBehavior: UICollisionBehavior!
    let cellSize = CGSizeMake(100, 100)
    let cellSpace: CGFloat = 20.0

    required override init() {
        super.init()
        self.dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
        self.dynamicAnimator.delegate = self
        self.collisionBehavior = UICollisionBehavior()
        self.dynamicAnimator.addBehavior(self.collisionBehavior)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        return self.dynamicAnimator.itemsInRect(rect)
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        if let attrs = self.dynamicAnimator.layoutAttributesForCellAtIndexPath(indexPath) {
            return attrs
        }
        var attrs = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attrs.size = self.cellSize
        attrs.center = CGPointMake(CGFloat(indexPath.row) * (cellSize.width + cellSpace) + cellSize.width / 2, CGFloat(indexPath.section) * (cellSize.height + cellSpace) + cellSize.height / 2)
        return attrs
//        return super.layoutAttributesForItemAtIndexPath(indexPath)
    }

    override func collectionViewContentSize() -> CGSize {
        if let collectionView = self.collectionView {
            return collectionView.bounds.size
        } else {
            return CGSizeZero
        }
    }

    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attrs = UICollectionViewLayoutAttributes(forCellWithIndexPath: itemIndexPath)
        attrs.size = self.cellSize
        attrs.center = CGPointMake(CGFloat(itemIndexPath.row) * (cellSize.width + cellSpace) + cellSize.width / 2, self.collectionViewContentSize().height + CGFloat(itemIndexPath.section) * (cellSize.height + cellSpace) + cellSize.height / 2)
        return attrs
    }

    override func prepareForCollectionViewUpdates(updateItems: [AnyObject]!) {
        super.prepareForCollectionViewUpdates(updateItems)
        for updateItem in updateItems {
            let updateAction = updateItem.updateAction!
            if updateAction == .Insert {
                let indexPath: NSIndexPath = (updateItem as! UICollectionViewUpdateItem).indexPathAfterUpdate!
                var attrs = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attrs.size = self.cellSize
                let center = CGPointMake(CGFloat(indexPath.row) * (cellSize.width + cellSpace) + cellSize.width / 2, CGFloat(indexPath.section) * (cellSize.height + cellSpace) + cellSize.height / 2)
                attrs.center = center
                var snapBehaviour = UISnapBehavior(item: attrs, snapToPoint: center)
                snapBehaviour.damping = 0.7
                self.dynamicAnimator.addBehavior(snapBehaviour)
                self.collisionBehavior.addItem(attrs)
            }
        }
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

extension MSTumblrMenuFlowLayout: UIDynamicAnimatorDelegate {

    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        // send the callback
    }
}
