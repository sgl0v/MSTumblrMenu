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

    override func viewDidLoad() {
//        let blurEffect = UIBlurEffect(style: .Light)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
//        self.view.insertSubview(blurView, atIndex: 0)
    }

//    override func viewDidLayoutSubviews() {
//        self.collectionView?.collectionViewLayout.invalidateLayout()
//    }

    // MARK: UICollectionViewControllerDataSource methods

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let menuCell = collectionView.dequeueReusableCellWithReuseIdentifier(MSTumblrMenuViewController.kMenuCellIdentifier, forIndexPath: indexPath) as! MSTumblrMenuCell
        return menuCell
    }

    // MARK: UICollectionViewControllerDelegate methods

}

extension MSTumblrMenuViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellSpacing: CGFloat = 20.0
        let width: CGFloat = CGRectGetWidth(collectionView.bounds)
        let numberOfItems: CGFloat = CGFloat(collectionView.dataSource!.collectionView(self.collectionView!, numberOfItemsInSection: indexPath.section))
        let cellWidth = (width - (numberOfItems + 1) * cellSpacing) / numberOfItems
        return CGSizeMake(cellWidth, cellWidth)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 20.0
    }

//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 20.0
//    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(20.0, 20.0, 0.0, 20.0)
    }


}
