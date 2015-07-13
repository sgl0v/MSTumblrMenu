//
//  MSTumblrMenuFlowLayout.swift
//  MSTumblrMenu
//
//  Created by Maksym Shcheglov on 13/07/15.
//  Copyright (c) 2015 Maksym Shcheglov. All rights reserved.
//

import UIKit

class MSTumblrMenuFlowLayout: UICollectionViewFlowLayout {

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

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    // MARK: Private
}
