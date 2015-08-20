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
    private var isInserted = false

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self.menuTransitioningDelegate
        self.collectionView!.viewForBaselineLayout().layer.speed = 0.5
    }

    override func viewDidLoad() {
        self.collectionView?.registerClass(MSTumblrMenuCell.self, forCellWithReuseIdentifier: MSTumblrMenuViewController.kMenuCellIdentifier)
    }

    func addItems() {
        guard let numberOfSections = self.dataSource?.numberOfSectionsInTumblrMenuViewController(self) else {
            return;
        }
        var items = [NSIndexPath]()
        for section in 0..<numberOfSections {
            let numberOfRows = self.dataSource!.tumblrMenuViewController(self, numberOfRowsInSection: section)
            for item in 0..<numberOfRows {
                items.append(NSIndexPath(forRow: item, inSection: section))
            }
        }
//        self.collectionView?.performBatchUpdates({
//            self.collectionView?.insertSections(NSIndexSet(indexesInRange: NSMakeRange(0, 1)))
            self.isInserted = true
            self.collectionView?.insertItemsAtIndexPaths(items)
//            }, completion: nil)
    }

    func removeItems() {
        guard let numberOfSections = self.dataSource?.numberOfSectionsInTumblrMenuViewController(self) else {
            return;
        }
        var items = [NSIndexPath]()
        for section in 0..<numberOfSections {
            let numberOfRows = self.dataSource!.tumblrMenuViewController(self, numberOfRowsInSection: section)
            for item in 0..<numberOfRows {
                items.append(NSIndexPath(forRow: item, inSection: section))
            }
        }
//        self.collectionView?.performBatchUpdates({
            self.isInserted = false
//        let layout = self.collectionViewLayout as! MSTumblrMenuLayout
//        layout.cachedAttributes = [NSIndexPath: MSTumblrMenuLayoutAttributes]()

            self.collectionView?.deleteItemsAtIndexPaths(items)
//            }, completion: nil)
    }

    // MARK: UICollectionViewControllerDataSource methods

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        guard self.isInserted else {
//            return 0
//        }
        return self.dataSource!.numberOfSectionsInTumblrMenuViewController(self)
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard self.isInserted else {
            return 0
        }
        return self.dataSource!.tumblrMenuViewController(self, numberOfRowsInSection: section)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let menuCell = collectionView.dequeueReusableCellWithReuseIdentifier(MSTumblrMenuViewController.kMenuCellIdentifier, forIndexPath: indexPath) as! MSTumblrMenuCell
        menuCell.image = self.dataSource?.tumblrMenuViewController(self, itemImageForRowAtIndexPath: indexPath)
        menuCell.title = self.dataSource?.tumblrMenuViewController(self, itemTitleForRowAtIndexPath: indexPath)
        return menuCell
    }

    // MARK: UICollectionViewControllerDelegate methods

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.tumblrMenuViewController(self, didSelectRowAtIndexPath: indexPath)
    }

}
