//
//  NSViewController+CustomSegue.swift
//  CustomSegue
//
//  Created by phimage on 19/08/16.
//  Copyright © 2016 phimage. All rights reserved.
//

import Foundation

public extension NSViewController {

    // How to present this view controller
    public enum PresentationMode {
        case AsModalWindow
        case AsSheet
        case AsPopover(relativeToRect: NSRect, ofView : NSView, preferredEdge: NSRectEdge, behavior: NSPopoverBehavior)
        case TransitionFrom(fromViewController: NSViewController, options: NSViewControllerTransitionOptions)
        case Animator(animator: NSViewControllerPresentationAnimator)
        case Segue(segueIdentifier: String)
    }

    // Present this view controller using parent controller.
    public func present(mode: PresentationMode) {
        assert(self.parentViewController != nil)
        if let p = self.parentViewController {
            switch mode {
            case .AsSheet:
                p.presentViewControllerAsSheet(self)
            case .AsModalWindow:
                p.presentViewControllerAsModalWindow(self)
            case .AsPopover(let positioningRect, let positioningView, let preferredEdge, let behavior):
                p.presentViewController(self, asPopoverRelativeToRect: positioningRect, ofView : positioningView, preferredEdge: preferredEdge, behavior: behavior)
            case .TransitionFrom(let fromViewController, let options):
                p.transitionFromViewController(fromViewController, toViewController: self, options: options, completionHandler: nil)
            case .Animator(let animator):
                p.presentViewController(self, animator: animator)
            case .Segue(let segueIdentifier):
                p.performSegueWithIdentifier(segueIdentifier, sender: self)
            }
        }
    }
    
}