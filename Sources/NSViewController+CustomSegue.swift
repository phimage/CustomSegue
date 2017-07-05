//
//  NSViewController+CustomSegue.swift
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

import Foundation

public extension NSViewController {

    // How to present this view controller
    public enum PresentationMode {
        case asModalWindow
        case asSheet
        case asPopover(relativeToRect: NSRect, ofView : NSView, preferredEdge: NSRectEdge, behavior: NSPopover.Behavior)
        case transitionFrom(fromViewController: NSViewController, options: NSViewController.TransitionOptions)
        case animator(animator: NSViewControllerPresentationAnimator)
        case segue(segueIdentifier: String)
    }

    // Present this view controller using parent controller.
    public func present(_ mode: PresentationMode) {
        assert(self.parent != nil)
        if let p = self.parent {
            switch mode {
            case .asSheet:
                p.presentViewControllerAsSheet(self)
            case .asModalWindow:
                p.presentViewControllerAsModalWindow(self)
            case .asPopover(let positioningRect, let positioningView, let preferredEdge, let behavior):
                p.presentViewController(self, asPopoverRelativeTo: positioningRect, of : positioningView, preferredEdge: preferredEdge, behavior: behavior)
            case .transitionFrom(let fromViewController, let options):
                p.transition(from: fromViewController, to: self, options: options, completionHandler: nil)
            case .animator(let animator):
                p.presentViewController(self, animator: animator)
            case .segue(let segueIdentifier):
                p.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: segueIdentifier), sender: self)
            }
        }
    }
    
}
