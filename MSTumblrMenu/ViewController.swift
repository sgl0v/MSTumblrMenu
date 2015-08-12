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
    private let images = [["post_type_bubble_chat", "post_type_bubble_link", "post_type_bubble_photo"], ["post_type_bubble_quote", "post_type_bubble_text", "post_type_bubble_video"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showMenu(sender: UIButton) {
        let toViewController = MSTumblrMenuViewController(collectionViewLayout: MSTumblrMenuFlowLayout())
        toViewController.dataSource = self
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
        return images[section].count
    }

    func numberOfSectionsInTumblrMenuViewController(tumblrMenuViewController: MSTumblrMenuViewController) -> Int {
        return images.count
    }

    func tumblrMenuViewController(tumblrMenuViewController: MSTumblrMenuViewController, itemImageForRowAtIndexPath indexPath: NSIndexPath) -> UIImage? {
        return UIImage(named: self.images[indexPath.section][indexPath.row])
    }
}

