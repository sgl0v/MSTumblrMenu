//
//  MSTumblrMenuViewController.swift
//  MSTumblrMenu
//
//  Created by Maksym Shcheglov on 09/07/15.
//  Copyright (c) 2015 Maksym Shcheglov. All rights reserved.
//

import UIKit

protocol MSTumblrMenuViewControllerDataSource: NSObjectProtocol {

    func tumblrMenuViewController(tumblrMenuViewController: MSTumblrMenuViewController, numberOfRowsInSection section: Int) -> Int
    func numberOfSectionsInTumblrMenuViewController(tumblrMenuViewController: MSTumblrMenuViewController) -> Int
    func tumblrMenuViewController(tumblrMenuViewController: MSTumblrMenuViewController, itemImageForRowAtIndexPath indexPath: NSIndexPath) -> UIImage?
    func tumblrMenuViewController(tumblrMenuViewController: MSTumblrMenuViewController, itemTitleForRowAtIndexPath indexPath: NSIndexPath) -> String?
}

protocol MSTumblrMenuViewControllerDelegate: NSObjectProtocol {

    func tumblrMenuViewController(tumblrMenuViewController: MSTumblrMenuViewController, didSelectRowAtIndexPath indexPath: NSIndexPath)
}

class MSTumblrMenuViewController: UICollectionViewController {

    static let kMenuCellIdentifier = "MenuCellIdentifier"
    weak var dataSource: MSTumblrMenuViewControllerDataSource?
    weak var delegate: MSTumblrMenuViewControllerDelegate?
    private let menuTransitioningDelegate = MSTumblrMenuTransitioningDelegate()
    private var animationStartTime : CFTimeInterval = 0.0
    private var displayLink : CADisplayLink?
    private var animationCounter = 0
    private let animationDuration = 0.2
    private var numberOfRows = [Int](count: 2, repeatedValue: 0)

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self.menuTransitioningDelegate
        self.collectionView!.viewForBaselineLayout().layer.speed = 0.5 // slow down the default insert/delete animation duration
    }

    override func viewDidLoad() {
        self.collectionView?.registerClass(MSTumblrMenuCell.self, forCellWithReuseIdentifier: MSTumblrMenuViewController.kMenuCellIdentifier)
    }

    func addItems() {
        guard let _ = self.dataSource?.numberOfSectionsInTumblrMenuViewController(self) else {
            return;
        }
        self.animationStartTime = CACurrentMediaTime()
        self.animationCounter = 0
        self.displayLink = CADisplayLink(target: self, selector: "animateInsert:")
        self.displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }

    func animateInsert(displayLink: CADisplayLink) {
        let split = self.displayLink!.timestamp - self.animationStartTime
        if split < Double(self.animationCounter) * self.animationDuration {
            return
        }

        let numberOfSections = self.dataSource!.numberOfSectionsInTumblrMenuViewController(self)
        let numberOfRows = self.dataSource!.tumblrMenuViewController(self, numberOfRowsInSection: 0)
        let itemToInsert = NSIndexPath(forRow: self.animationCounter % numberOfRows, inSection: self.animationCounter / numberOfRows)
        self.animationCounter++
        self.numberOfRows[itemToInsert.section] = self.numberOfRows[itemToInsert.section] + 1
        dispatch_async(dispatch_get_main_queue()) {
            self.collectionView?.insertItemsAtIndexPaths([itemToInsert])
        }

        if self.animationCounter == numberOfRows * numberOfSections {
            self.displayLink!.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
            self.displayLink = nil
        }
    }

    func removeItems() {
        guard let _ = self.dataSource?.numberOfSectionsInTumblrMenuViewController(self) else {
            return;
        }
        self.animationStartTime = CACurrentMediaTime()
        self.animationCounter = 0
        self.displayLink = CADisplayLink(target: self, selector: "animateRemove:")
        self.displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }

    func animateRemove(displayLink: CADisplayLink) {
        let split = self.displayLink!.timestamp - self.animationStartTime
        if split < Double(self.animationCounter) * self.animationDuration {
            return
        }

        let numberOfSections = self.dataSource!.numberOfSectionsInTumblrMenuViewController(self)
        let numberOfRows = self.dataSource!.tumblrMenuViewController(self, numberOfRowsInSection: 0)
        let section = self.animationCounter / numberOfRows
        let itemToDelete = NSIndexPath(forRow: self.numberOfRows[section] - 1, inSection: section)
        self.animationCounter++
        self.numberOfRows[itemToDelete.section] = self.numberOfRows[section] - 1
        dispatch_async(dispatch_get_main_queue()) {
            self.collectionView?.deleteItemsAtIndexPaths([itemToDelete])
        }

        if self.animationCounter == numberOfRows * numberOfSections {
            self.displayLink!.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
            self.displayLink = nil
        }
    }

    // MARK: UICollectionViewControllerDataSource methods

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.dataSource!.numberOfSectionsInTumblrMenuViewController(self)
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource!.tumblrMenuViewController(self, numberOfRowsInSection: section)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let menuCell = collectionView.dequeueReusableCellWithReuseIdentifier(MSTumblrMenuViewController.kMenuCellIdentifier, forIndexPath: indexPath) as! MSTumblrMenuCell
        menuCell.image = self.dataSource?.tumblrMenuViewController(self, itemImageForRowAtIndexPath: indexPath)
        menuCell.title = self.dataSource?.tumblrMenuViewController(self, itemTitleForRowAtIndexPath: indexPath)

//        UIView.beginAnimations("transform", context: nil)
//        UIView.setAnimationDuration(3)
//        //        UIView.setAnimationDelay(menuCell.layer.convertTime(CACurrentMediaTime(), fromLayer: nil) + 0.2)
//        CATransaction.begin()
//        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(controlPoints: 0.3, 0.5, 1.0, 1.0))
//        menuCell.layer.transform = CATransform3DIdentity
//        CATransaction.commit()
//        UIView.commitAnimations()

        let duration = 0.36
        let animationInterval = duration / 5
//        let numberOfSections = self.dataSource!.numberOfSectionsInTumblrMenuViewController(self)
        let numberOfRows = self.dataSource!.tumblrMenuViewController(self, numberOfRowsInSection: indexPath.section)
        var delayInSeconds = Double(indexPath.section) * Double(numberOfRows) * animationInterval
        if (indexPath.row == 0) {
            delayInSeconds += animationInterval
        } else if (indexPath.row == numberOfRows - 1) {
            delayInSeconds += 2 * animationInterval
        }

        let yOffset = CGRectGetHeight(self.collectionView!.bounds)
        menuCell.layer.transform = CATransform3DMakeTranslation(0, yOffset, 0)

//        let positionAnimation  = CABasicAnimation(keyPath: "transform")
//        positionAnimation.fromValue = NSValue.init(CATransform3D: CATransform3DMakeTranslation(0, CGRectGetHeight(self.collectionView!.bounds), 0))
//        positionAnimation.toValue = NSValue.init(CATransform3D: CATransform3DIdentity)
//        positionAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.3, 0.5, 1.0, 1.0);
//        positionAnimation.duration = duration;
////        positionAnimation.removedOnCompletion = false;
////        positionAnimation.fillMode = kCAFillModeForwards;
//        positionAnimation.beginTime = delayInSeconds + menuCell.layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
//        menuCell.contentView.layer.addAnimation(positionAnimation, forKey: "positionAnimation")

        UIView.animateWithDuration(duration, delay: delayInSeconds, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            menuCell.layer.transform = CATransform3DIdentity
            menuCell.layer.opacity = 1.0
            }, completion: nil)
        return menuCell
    }

    // MARK: UICollectionViewControllerDelegate methods

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.tumblrMenuViewController(self, didSelectRowAtIndexPath: indexPath)
    }

}
