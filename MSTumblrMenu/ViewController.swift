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
    private let images = [["post_type_bubble_text", "post_type_bubble_photo", "post_type_bubble_quote"], ["post_type_bubble_link", "post_type_bubble_chat", "post_type_bubble_video"]]
    private let titles = [["Text", "Photo", "Quote"], ["Link", "Chat", "Video"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showMenu(sender: UIButton) {
        let toViewController = MSTumblrMenuViewController(collectionViewLayout: MSTumblrMenuLayout())
        toViewController.dataSource = self
        toViewController.delegate = self
        self.presentViewController(toViewController, animated: true, completion: nil)
    }

    @IBAction func unwindToViewController(sender: UIStoryboardSegue) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toViewController = segue.destinationViewController as UIViewController
        toViewController.transitioningDelegate = self.menuTransitioningDelegate
        toViewController.modalPresentationStyle = .Custom
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
