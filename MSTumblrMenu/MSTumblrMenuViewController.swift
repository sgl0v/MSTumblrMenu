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
    private var animationType = MSTumblrMenuAnimation.None

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
        menuCell.addAnimation(animation(forCell: menuCell, indexPath:indexPath))

        return menuCell
    }

    // MARK: UICollectionViewControllerDelegate methods

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.tumblrMenuViewController(self, didSelectRowAtIndexPath: indexPath)
    }

    // MARK: Private

    private func animation(forCell cell: MSTumblrMenuCell, indexPath: NSIndexPath) -> MSTumblrMenuCellAnimation? {
        let animationInterval = MSTumblrMenuCellAnimationConstants.duration / 10.0
        let numberOfSections = self.dataSource!.numberOfSectionsInTumblrMenuViewController(self)
        let numberOfRows = self.dataSource!.tumblrMenuViewController(self, numberOfRowsInSection: indexPath.section)
        var delayInSeconds = Double(indexPath.section) * Double(numberOfRows) * animationInterval
        if (indexPath.row == 0) {
            delayInSeconds += animationInterval
        } else if (indexPath.row == numberOfRows - 1) {
            delayInSeconds += 2 * animationInterval
        }

        let offset = CGRectGetHeight(self.collectionView!.bounds) / 2

        switch self.animationType {
        case .Show:
            return MSTumblrMenuCellAnimation(delay: delayInSeconds, initialAction: { cell in
                cell.layer.transform = CATransform3DMakeTranslation(0, offset + CGFloat(indexPath.section) * 200.0, 0)
                cell.layer.opacity = 0.0
                }, animationAction: { cell in
                    cell.layer.transform = CATransform3DIdentity
                    cell.layer.opacity = 1.0
            })
        case .Hide:
            return MSTumblrMenuCellAnimation(delay: delayInSeconds, initialAction: { cell in
                cell.layer.transform = CATransform3DIdentity
                cell.layer.opacity = 1.0
                }, animationAction: { cell in
                    cell.layer.transform = CATransform3DMakeTranslation(0, -(offset + CGFloat(numberOfSections - indexPath.section) * 200.0), 0)
                    cell.layer.opacity = 0.0
            })
        default:
            return nil
        }
    }

}
