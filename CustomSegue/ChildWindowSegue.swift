//
//  ChildWindowSegue.swift
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

// Segue to present controller in a new NSWindow
public final class ChildWindowSegue: PresentWithAnimatorSegue {
    override init(identifier: String, source sourceController: AnyObject, destination destinationController: AnyObject) {
        super.init(identifier: identifier, source: sourceController, destination: destinationController)
        animator = ChildWindowAnimator()
    }
}

// Animator for ChildWindowSegue
public class ChildWindowAnimator: NSObject, NSViewControllerPresentationAnimator {
    
    // Customize created NSWindow
    public var windowCustomizer: ((NSWindow) -> Void)? = nil
    // Place when adding child window
    public var place: NSWindowOrderingMode = .Above
    
    // Create the NSWindow
    public var windowFactory: ((contentViewController: NSViewController) -> NSWindow) = { contentViewController in
        return NSWindow(contentViewController: contentViewController)
    }
    
    public func animatePresentationOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
        if viewController.view.window == nil {
            let window = windowFactory(contentViewController: viewController)
            window.appearance = fromViewController.view.window?.appearance
            self.windowCustomizer?(window)
            fromViewController.view.window?.addChildWindow(window, ordered: place)
        }
    }

    public func animateDismissalOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
        if let window = viewController.view.window {
            fromViewController.view.window?.removeChildWindow(window)
        }
    }

}