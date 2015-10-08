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

enum MSTumblrMenuAnimation: UInt {
    case None, Show, Hide
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
    private let duration = 1.0
    private var animationType = MSTumblrMenuAnimation.None
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
//        self.collectionView!.viewForBaselineLayout().layer.speed = 0.5 // slow down the default insert/delete animation duration
    }

    override func viewDidLoad() {
        self.collectionView?.registerClass(MSTumblrMenuCell.self, forCellWithReuseIdentifier: MSTumblrMenuViewController.kMenuCellIdentifier)
    }

    func show() {
        self.animationType = .Show
        self.collectionView!.reloadData()
    }

    func hide() {
        self.animationType = .Hide
        self.collectionView!.reloadData()
    }

    func completeAnimation() {
        self.animationType = .None
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.collectionView!.reloadData()
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

        animateCellIfNeeded(menuCell, indexPath: indexPath)

        return menuCell
    }

    private func animateCellIfNeeded(cell: MSTumblrMenuCell, indexPath: NSIndexPath) {
        let animationInterval = duration / 10
        let numberOfSections = self.dataSource!.numberOfSectionsInTumblrMenuViewController(self)
        let numberOfRows = self.dataSource!.tumblrMenuViewController(self, numberOfRowsInSection: indexPath.section)
        var delayInSeconds = Double(indexPath.section) * Double(numberOfRows) * animationInterval
        if (indexPath.row == 0) {
            delayInSeconds += animationInterval
        } else if (indexPath.row == numberOfRows - 1) {
            delayInSeconds += 2 * animationInterval
        }

        if (self.animationType == .Show) {

            let yOffset = CGRectGetHeight(self.collectionView!.bounds) / 2 + CGFloat(indexPath.section) * 200.0
            cell.layer.transform = CATransform3DMakeTranslation(0, yOffset, 0)
            cell.layer.opacity = 0.0
            UIView.animateWithDuration(duration, delay: delayInSeconds, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [], animations: { () -> Void in
                cell.layer.transform = CATransform3DIdentity
                cell.layer.opacity = 1.0
                }, completion: nil)
        } else if (self.animationType == .Hide) {

            let yOffset = CGRectGetHeight(self.collectionView!.bounds) / 2 + CGFloat(numberOfSections - indexPath.section) * 200.0
            cell.layer.transform = CATransform3DIdentity
            cell.layer.opacity = 1.0
            UIView.animateWithDuration(duration, delay: delayInSeconds, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [], animations: { () -> Void in
                cell.layer.transform = CATransform3DMakeTranslation(0, -yOffset, 0)
                cell.layer.opacity = 0.0
                }, completion: nil)
        }
    }

    // MARK: UICollectionViewControllerDelegate methods

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.tumblrMenuViewController(self, didSelectRowAtIndexPath: indexPath)
    }

}
