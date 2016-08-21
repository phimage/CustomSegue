//
//  PresentWithAnimatorSegue.swift
//  CustomSegue
/*
 The MIT License (MIT)
 Copyright (c) 2016 Eric Marchand (phimage)
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import AppKit

// A segue with custom animator.
// You can configure the animator in `prepareForSegue`
public class PresentWithAnimatorSegue: NSStoryboardSegue {
    
    // An animator used to present the view controller. (by default an TransitionAnimator)
    public var animator: NSViewControllerPresentationAnimator = TransitionAnimator()
    // Add destination controller as child to source controller
    public var addAsChild = false
    
    override public func perform() {
        guard let fromController = self.sourceController as? NSViewController,
            let toController = self.destinationController as? NSViewController
            else { return }

        if toController.parentViewController == nil && addAsChild {
            fromController.addChildViewController(toController)
        }
        fromController.presentViewController(toController, animator: animator)
    }

}

// MARK: Utility class with transition type configured

// Slide down segue
public class SlideDownSegue: PresentWithAnimatorSegue {
    
    override init(identifier: String, source sourceController: AnyObject, destination destinationController: AnyObject) {
        super.init(identifier: identifier, source: sourceController, destination: destinationController)
        (animator as? TransitionAnimator)?.transition = [.SlideDown, .Crossfade]
    }
    
}

// Slide up segue
public class SlideUpSegue: PresentWithAnimatorSegue {
    
    override init(identifier: String, source sourceController: AnyObject, destination destinationController: AnyObject) {
        super.init(identifier: identifier, source: sourceController, destination: destinationController)
        (animator as? TransitionAnimator)?.transition = [.SlideUp, .Crossfade]
    }
    
}

// Slide left segue
public class SlideLeftSegue: PresentWithAnimatorSegue {
    
    override init(identifier: String, source sourceController: AnyObject, destination destinationController: AnyObject) {
        super.init(identifier: identifier, source: sourceController, destination: destinationController)
        (animator as? TransitionAnimator)?.transition = [.SlideLeft, .Crossfade]
    }
    
}

// Slide right segue
public class SlideRightSegue: PresentWithAnimatorSegue {
    
    override init(identifier: String, source sourceController: AnyObject, destination destinationController: AnyObject) {
        super.init(identifier: identifier, source: sourceController, destination: destinationController)
        (animator as? TransitionAnimator)?.transition = [.SlideRight, .Crossfade]
    }
    
}

// Crossfade segue
public class CrossfadeSegue: PresentWithAnimatorSegue {
    
    override init(identifier: String, source sourceController: AnyObject, destination destinationController: AnyObject) {
        super.init(identifier: identifier, source: sourceController, destination: destinationController)
        (animator as? TransitionAnimator)?.transition = .Crossfade
    }
    
}