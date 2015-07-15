//
//  MSTumblrMenuViewController.swift
//  MSTumblrMenu
//
//  Created by Maksym Shcheglov on 09/07/15.
//  Copyright (c) 2015 Maksym Shcheglov. All rights reserved.
//

import UIKit

class MSTumblrMenuViewController: UICollectionViewController {

    static let kMenuCellIdentifier = "MenuCellIdentifier"
    var numberOfSections = 2
    var numberOfItems = 0

    override func viewDidLoad() {
        self.collectionView?.registerClass(MSTumblrMenuCell.self, forCellWithReuseIdentifier: MSTumblrMenuViewController.kMenuCellIdentifier)

        var gestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissViewController:")
        self.collectionView?.addGestureRecognizer(gestureRecognizer)
//        let blurEffect = UIBlurEffect(style: .Light)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
//        self.view.insertSubview(blurView, atIndex: 0)
    }

    func dismissViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func addItems() {
        var items = [NSIndexPath]()
        for section in 0..<2 {
            for item in 0..<3 {
                items.append(NSIndexPath(forRow: item, inSection: section))
            }
        }
        self.collectionView?.performBatchUpdates({
//            self.collectionView?.insertSections(NSIndexSet(indexesInRange: NSMakeRange(0, 1)))
            self.collectionView?.insertItemsAtIndexPaths(items)
//            self.numberOfSections = 1
            self.numberOfItems = 3
        }, completion: nil)
    }

//    override func viewDidLayoutSubviews() {
//        self.collectionView?.collectionViewLayout.invalidateLayout()
//    }

    // MARK: UICollectionViewControllerDataSource methods

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.numberOfSections
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfItems
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let menuCell = collectionView.dequeueReusableCellWithReuseIdentifier(MSTumblrMenuViewController.kMenuCellIdentifier, forIndexPath: indexPath) as! MSTumblrMenuCell
        return menuCell
    }

}

//extension MSTumblrMenuViewController: UICollectionViewDelegateFlowLayout
//{
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSizeMake(100, 100)
//    }
//}

//extension MSTumblrMenuViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let cellSpacing: CGFloat = 20.0
//        let width: CGFloat = CGRectGetWidth(collectionView.bounds)
//        let numberOfItems: CGFloat = CGFloat(collectionView.dataSource!.collectionView(self.collectionView!, numberOfItemsInSection: indexPath.section))
//        let cellWidth = (width - (numberOfItems + 1) * cellSpacing) / numberOfItems
//        return CGSizeMake(cellWidth, cellWidth)
//    }
//
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 20.0
//    }
//
////    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
////        return 20.0
////    }
//
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        return UIEdgeInsetsMake(20.0, 20.0, 0.0, 20.0)
//    }
//
//
//}
