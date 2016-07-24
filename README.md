# CustomSegue

[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat
            )](http://mit-license.org)
[![Platform](http://img.shields.io/badge/platform-osx-lightgrey.svg?style=flat
             )](https://developer.apple.com/resources/)
[![Language](http://img.shields.io/badge/language-swift-orange.svg?style=flat
             )](https://developer.apple.com/swift)
[![Issues](https://img.shields.io/github/issues/phimage/CustomSegue.svg?style=flat
           )](https://github.com/phimage/CustomSegue/issues)
[![Cocoapod](http://img.shields.io/cocoapods/v/CustomSegue.svg?style=flat)](http://cocoadocs.org/docsets/CustomSegue/)

[<img align="left" src="logo.png" hspace="20">](#logo)
Custom segue for OSX Storyboards with slide and cross fade effects.
```swift
class MyViewController: NSViewController {
  override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "configured" {
          if let segue = segue as? PresentWithAnimatorSegue, animator = segue.animator as? TransitionAnimator {

              animator.duration = 1
              animator.transition = [.SlideDown/, .Crossfade]
              animator.backgroundColor = NSColor(calibratedRed: 1, green: 0, blue: 0, alpha: 0.5)
              animator.keepOriginalSize = true
              animator.removeFromView = false
          }
      }
  }
```

Segue transition is configured via [NSViewControllerTransitionOptions](https://developer.apple.com/reference/appkit/nsviewcontrollertransitionoptions)

## How to use
Use `PresentWithAnimatorSegue` in your storyboard or use one of already configured segue: `SlideDownSegue`, `SlideUpSegue`,...

## Installation

## Using CocoaPods ##
[CocoaPods](https://cocoapods.org/) is a centralized dependency manager for
Objective-C and Swift. Go [here](https://guides.cocoapods.org/using/index.html)
to learn more.

1. Add the project to your [Podfile](https://guides.cocoapods.org/using/the-podfile.html).

    ```ruby
    use_frameworks!

    pod 'CustomSegue'
    ```

2. Run `pod install` and open the `.xcworkspace` file to launch Xcode.
