//
//  TransitionFromViewSegue.swift
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

// Segue using parent controller of source and `transitionFromViewController`
open class TransitionFromViewSegue: NSStoryboardSegue {
    
    // Animation options for view transitions
    open var transition: NSViewController.TransitionOptions =  [.crossfade, .slideDown]
    // Handler for transition completion
    open var completionHandler: (() -> Void)?
    // Set wants layer or not for all controller main view
    open var wantsLayer = true
    
    override open func perform() {
        guard let fromController = self.sourceController as? NSViewController,
            let toController = self.destinationController as? NSViewController
            else { return }

        if let parentViewController = fromController.parent {
            parentViewController.addChildViewController(toController)

            if wantsLayer {
                parentViewController.view.wantsLayer = true
                fromController.view.wantsLayer = true
                toController.view.wantsLayer = true
            }

            parentViewController.transition(from: fromController, to: toController, options: transition, completionHandler: completionHandler)
        }
    }
    
}
