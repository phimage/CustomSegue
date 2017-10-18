//
//  TransitionAnimator.swift
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

// Simple enum for transition type.
public enum TransitionType {
    case present, dismiss
}

// Protocol that view controllers can implement to receive notification of transition.
// This could be used to change controller behaviours.
public protocol TransitionAnimatorNotifiable {
  
    // Notify the transition completion
    func notifyTransitionCompletion(_ transition: TransitionType)
}

// An animator to present view controller using NSViewControllerTransitionOptions
open class TransitionAnimator: NSObject, NSViewControllerPresentationAnimator {

    // Duration of animation (default: 0.3)
    open var duration: TimeInterval
    // Animation options for view transitions
    open var transition: NSViewController.TransitionOptions
    // Background color used on destination controller if not already defined
    open var backgroundColor = NSColor.windowBackgroundColor
    // If false, destination controller take the size of the source controller
    // If true, when sliding the destination controller keep one of its size element.(ex: for slide down and up, the height is kept)
    // (default: false)
    open var keepOriginalSize = false
    // Remove view of fromViewController from view hierarchy. Best use with crossfade effect.
    open var removeFromView = false
    // Optional origin point for displayed view
    open var origin: NSPoint? = nil {
        didSet {
            assert(keepOriginalSize)
        }
    }
    
    fileprivate var fromView: NSView? = nil

    // Init
    public init(duration: TimeInterval =  0.3, transition: NSViewController.TransitionOptions = [NSViewController.TransitionOptions.crossfade, NSViewController.TransitionOptions.slideDown]) {
        self.duration = duration
        self.transition = transition
    }

    // MARK: NSViewControllerPresentationAnimator
    
    
    @objc open func animatePresentation(of viewController: NSViewController, from fromViewController: NSViewController) {
        let fromFrame = fromViewController.view.frame

        let originalFrame = viewController.view.frame
        let startFrame = transition.slideStartFrame(fromFrame: fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
        var destinationFrame = transition.slideStopFrame(fromFrame: fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
        
        if let origin = self.origin {
            destinationFrame.origin = origin
        }

        viewController.view.frame = startFrame
        viewController.view.autoresizingMask = [NSView.AutoresizingMask.width, NSView.AutoresizingMask.height]

        if transition.contains(NSViewController.TransitionOptions.crossfade) {
            viewController.view.alphaValue = 0
        }

        if !viewController.view.wantsLayer { // remove potential transparency
            viewController.view.wantsLayer = true
            viewController.view.layer?.backgroundColor = backgroundColor.cgColor
            viewController.view.layer?.isOpaque = true
        }
        // maybe create an intermediate container view to remove from controller view from hierarchy
        if removeFromView {
            fromView = fromViewController.view
            fromViewController.view = NSView(frame: fromViewController.view.frame)
            fromViewController.view.addSubview(fromView!)
        }
        fromViewController.view.addSubview(viewController.view)

        NSAnimationContext.runAnimationGroup(
            { [unowned self] context in
                context.duration = self.duration
                context.timingFunction =  CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                
                viewController.view.animator().frame = destinationFrame
                if self.transition.contains(NSViewController.TransitionOptions.crossfade) {
                    viewController.view.animator().alphaValue = 1
                    self.fromView?.animator().alphaValue = 0
                }
                
            }, completionHandler: { [unowned self] in
                if self.removeFromView {
                    self.fromView?.removeFromSuperview()
                }
                if let src = viewController as? TransitionAnimatorNotifiable {
                    src.notifyTransitionCompletion(.present)
                }
                if let dst = viewController as? TransitionAnimatorNotifiable {
                    dst.notifyTransitionCompletion(.present)
                }
        })
    }

    @objc open func animateDismissal(of viewController: NSViewController, from fromViewController: NSViewController) {
        let fromFrame = fromViewController.view.frame
        let originalFrame = viewController.view.frame
        let destinationFrame = transition.slideStartFrame(fromFrame: fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
        
        if self.removeFromView {
            fromViewController.view.addSubview(self.fromView!)
        }
        
        NSAnimationContext.runAnimationGroup(
            { [unowned self] context in
                context.duration = self.duration
                context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                
                viewController.view.animator().frame = destinationFrame
                if self.transition.contains(NSViewController.TransitionOptions.crossfade) {
                    viewController.view.animator().alphaValue = 0
                    self.fromView?.animator().alphaValue = 1
                }

            }, completionHandler: {
                viewController.view.removeFromSuperview()
                if self.removeFromView {
                    if let view = self.fromView {
                        fromViewController.view = view
                    }
                }
                
                if let src = viewController as? TransitionAnimatorNotifiable {
                    src.notifyTransitionCompletion(.dismiss)
                }
                if let dst = viewController as? TransitionAnimatorNotifiable {
                    dst.notifyTransitionCompletion(.dismiss)
                }
        })
    }
}


// MARK: NSViewControllerTransitionOptions

extension NSViewController.TransitionOptions {
    
    func slideStartFrame(fromFrame: NSRect, keepOriginalSize: Bool, originalFrame: NSRect) -> NSRect {
        if self.contains(NSViewController.TransitionOptions.slideLeft) {
            let width = keepOriginalSize ? originalFrame.width : fromFrame.width
            return NSRect(x: fromFrame.width, y: 0, width: width, height: fromFrame.height)
        }
        if self.contains(NSViewController.TransitionOptions.slideRight) {
            let width = keepOriginalSize ? originalFrame.width : fromFrame.width
            return NSRect(x: -width, y: 0, width: width, height: fromFrame.height)
        }
        if self.contains(NSViewController.TransitionOptions.slideDown) {
            let height = keepOriginalSize ? originalFrame.height : fromFrame.height
            return NSRect(x: 0, y: fromFrame.height, width: fromFrame.width, height: height)
        }
        if self.contains(NSViewController.TransitionOptions.slideUp) {
            let height = keepOriginalSize ? originalFrame.height : fromFrame.height
            return NSRect(x: 0, y: -height, width: fromFrame.width, height: height)
        }
        if self.contains(NSViewController.TransitionOptions.slideForward) {
            switch NSApp.userInterfaceLayoutDirection {
            case .leftToRight:
                return NSViewController.TransitionOptions.slideLeft.slideStartFrame(fromFrame: fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            case .rightToLeft:
                return NSViewController.TransitionOptions.slideRight.slideStartFrame(fromFrame: fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            }
        }
        if self.contains(NSViewController.TransitionOptions.slideBackward) {
            switch NSApp.userInterfaceLayoutDirection {
            case .leftToRight:
                return NSViewController.TransitionOptions.slideRight.slideStartFrame(fromFrame: fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            case .rightToLeft:
                return NSViewController.TransitionOptions.slideLeft.slideStartFrame(fromFrame: fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            }
        }
        return fromFrame
    }
    
    func slideStopFrame(fromFrame: NSRect, keepOriginalSize: Bool, originalFrame: NSRect) -> NSRect {
        if !keepOriginalSize {
            return fromFrame
        }
        if self.contains(NSViewController.TransitionOptions.slideLeft) {
            return NSRect(x: fromFrame.width - originalFrame.width , y: 0, width: originalFrame.width , height: fromFrame.height)
        }
        if self.contains(NSViewController.TransitionOptions.slideRight) {
            return NSRect(x: 0, y: 0, width: originalFrame.width , height: fromFrame.height)
        }
        if self.contains(NSViewController.TransitionOptions.slideUp) {
            return NSRect(x: 0, y: 0, width: fromFrame.width, height: originalFrame.height )
        }
        if self.contains(NSViewController.TransitionOptions.slideDown) {
            return NSRect(x: 0, y: fromFrame.height - originalFrame.height , width: fromFrame.width, height: originalFrame.height)
        }
        if self.contains(NSViewController.TransitionOptions.slideForward) {
            switch NSApp.userInterfaceLayoutDirection {
            case .leftToRight:
                return NSViewController.TransitionOptions.slideLeft.slideStopFrame(fromFrame: fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            case .rightToLeft:
                return NSViewController.TransitionOptions.slideRight.slideStopFrame(fromFrame: fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            }
        }
        if self.contains(NSViewController.TransitionOptions.slideBackward) {
            switch NSApp.userInterfaceLayoutDirection {
            case .leftToRight:
                return NSViewController.TransitionOptions.slideRight.slideStopFrame(fromFrame: fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            case .rightToLeft:
                return NSViewController.TransitionOptions.slideLeft.slideStopFrame(fromFrame: fromFrame, keepOriginalSize: keepOriginalSize, originalFrame: originalFrame)
            }
        }
        return fromFrame
    }
    
}
