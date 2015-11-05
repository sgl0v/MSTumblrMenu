//
//  ViewController.swift
//  MSTumblrMenu
//
//  Created by Maksym Shcheglov on 09/07/15.
//  Copyright (c) 2015 Maksym Shcheglov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let menuTransitioningDelegate = MSTumblrMenuTransitioningDelegate()
    private var images: Array<Array<String>>!
    private var titles: Array<Array<String>>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func show3x2Menu(sender: UIButton) {
        self.images = [["post_type_bubble_text", "post_type_bubble_photo", "post_type_bubble_quote"], ["post_type_bubble_link", "post_type_bubble_chat","post_type_bubble_video"]]
        self.titles = [["Text", "Photo", "Quote"], ["Link", "Chat", "Video"]]
        let rows : CGFloat = 3
        let width = CGRectGetWidth(self.view.bounds);
        let itemSpacing : CGFloat = 15
        let cellWidth = (width - itemSpacing * (rows + 1)) / rows
        self.presentMenuController(CGSizeMake(cellWidth, cellWidth + 20), itemSpacing: itemSpacing)
    }

    @IBAction func show4x3Menu(sender: UIButton) {
        self.images = [["post_type_bubble_text", "post_type_bubble_photo", "post_type_bubble_quote", "post_type_bubble_text"], ["post_type_bubble_link", "post_type_bubble_chat","post_type_bubble_video", "post_type_bubble_link"], ["post_type_bubble_link", "post_type_bubble_chat","post_type_bubble_video", "post_type_bubble_link"]]
        self.titles = [["Text", "Photo", "Quote", "Text"], ["Link", "Chat", "Video", "Link"], ["Link", "Chat", "Video", "Link"]]
        self.presentMenuController(CGSizeMake(70, 90), itemSpacing: 10.0)
    }

    @IBAction func show5x5Menu(sender: UIButton) {
        self.images = [["post_type_bubble_text", "post_type_bubble_photo", "post_type_bubble_quote", "post_type_bubble_text", "post_type_bubble_text"], ["post_type_bubble_link", "post_type_bubble_chat","post_type_bubble_video", "post_type_bubble_link", "post_type_bubble_chat"], ["post_type_bubble_text", "post_type_bubble_photo", "post_type_bubble_quote", "post_type_bubble_text", "post_type_bubble_text"], ["post_type_bubble_text", "post_type_bubble_photo", "post_type_bubble_quote", "post_type_bubble_text", "post_type_bubble_text"], ["post_type_bubble_text", "post_type_bubble_photo", "post_type_bubble_quote", "post_type_bubble_text", "post_type_bubble_text"]]
        self.titles = [["Text", "Photo", "Quote", "Text", "Photo"], ["Link", "Chat", "Video", "Link", "Chat"], ["Text", "Photo", "Quote", "Text", "Photo"], ["Text", "Photo", "Quote", "Text", "Photo"], ["Text", "Photo", "Quote", "Text", "Photo"]]
        self.presentMenuController(CGSizeMake(50, 70), itemSpacing: 7.0)
    }

    @IBAction func unwindToViewController(sender: UIStoryboardSegue) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toViewController = segue.destinationViewController as UIViewController
        toViewController.transitioningDelegate = self.menuTransitioningDelegate
        toViewController.modalPresentationStyle = .Custom
    }

    private func presentMenuController(itemSize: CGSize, itemSpacing: CGFloat) {
        let toViewController = MSTumblrMenuViewController(collectionViewLayout: MSTumblrMenuLayout(itemSize: itemSize, itemSpacing: itemSpacing))
        toViewController.dataSource = self
        toViewController.delegate = self
        self.presentViewController(toViewController, animated: true, completion: nil)
    }
}

extension ViewController: MSTumblrMenuViewControllerDataSource
{
    func tumblrMenuViewController(tumblrMenuViewController: MSTumblrMenuViewController, numberOfRowsInSection section: Int) -> Int {
        return self.images[section].count
    }

    func numberOfSectionsInTumblrMenuViewController(tumblrMenuViewController: MSTumblrMenuViewController) -> Int {
        return self.images.count
    }

    func tumblrMenuViewController(tumblrMenuViewController: MSTumblrMenuViewController, itemImageForRowAtIndexPath indexPath: NSIndexPath) -> UIImage? {
        return UIImage(named: self.images[indexPath.section][indexPath.row])
    }

    func tumblrMenuViewController(tumblrMenuViewController: MSTumblrMenuViewController, itemTitleForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return self.titles[indexPath.section][indexPath.row]
    }
}


extension ViewController: MSTumblrMenuViewControllerDelegate
{
    func tumblrMenuViewController(tumblrMenuViewController: MSTumblrMenuViewController, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
