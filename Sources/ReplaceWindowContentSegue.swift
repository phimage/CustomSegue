//
//  ReplaceWindowContentSegue.swift
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

// Replace contentViewController of sourceController parent NSWindow by destinationController
open class ReplaceWindowContentSegue: NSStoryboardSegue {
    
    open var copyFrame = false

    open override func perform() {
        guard let fromController = self.sourceController as? NSViewController,
            let toController = self.destinationController as? NSViewController,
            let window = fromController.view.window
            else { return }
        if copyFrame {
            toController.view.frame = fromController.view.frame
        }
        window.contentViewController = toController
    }

    // In prepareForSegue of sourceController, store this segue into destinationController
    // Then you can call this method to dismiss the destinationController
    open func unperform() {
        guard let fromController = self.sourceController as? NSViewController,
            let toController = self.destinationController as? NSViewController,
            let window = toController.view.window
            else { return }
        
        if copyFrame {
            fromController.view.frame = toController.view.frame
        }
        window.contentViewController = fromController
    }

}
