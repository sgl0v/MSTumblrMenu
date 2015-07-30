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

