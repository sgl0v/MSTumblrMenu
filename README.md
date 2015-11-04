MSTumblrMenu
===============
[[Overview](#overview) &bull; [Installation](#installation) &bull; [Demo](#demo) &bull; [Requirements](#requirements) &bull; [Licence](#licence)] 

<br>

![Alt text](https://raw.githubusercontent.com/sgl0v/MSColorPicker/master/screenshots/sample_iphone.gif)

##<a name="overview"></a>Overview


The menu component, that looks like the Tumblr one.

* Written in Swift, uses `UICollectionView`
* Based on the View Controller Transitioning API, introduced in the iOS 7
* Uses core animation to animate the menu and items appearance

## Installation

Simply create the `MSTumblrMenuViewController`'s instance and assing dataSource and delegate:

```
let toViewController = MSTumblrMenuViewController(collectionViewLayout: MSTumblrMenuLayout(itemSize: itemSize, itemSpacing: itemSpacing))
toViewController.dataSource = self
toViewController.delegate = self
self.presentViewController(toViewController, animated: true, completion: nil)

```

Implement the `MSTumblrMenuViewControllerDataSource` and `MSTumblrMenuViewControllerDelegate` protocols to provide the menu items details and callback handling:

```
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
```

## Demo

Build and run the <i>MSTumblrMenu</i> project in Xcode. The demo demonstrates how to use and integrate the MSTUmblrMenu into your project.

##<a name="overview"></a>Requirements

- Requires iOS 8.0 or later (In theory should work with iOS 7.0, not tested)
- Requires Automatic Reference Counting (ARC)
- Tested with Xcode 7.1
 
##<a name="licence"></a>Licence

`MSTumblrMenu` is MIT-licensed. See `LICENSE`. 