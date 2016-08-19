//
//  ChildWindowSegue.swift
//  CustomSegue
//
//  Created by phimage on 19/08/16.
//  Copyright © 2016 phimage. All rights reserved.
//

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
    
    public func animatePresentationOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
        if viewController.view.window == nil {
            let window = NSWindow(contentViewController: viewController)
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