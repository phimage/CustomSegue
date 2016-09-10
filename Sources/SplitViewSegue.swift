//
//  SplitViewSegue.swift
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

// Segue that replace the last split view item if sourceController is in NSSplitViewController
open class SplitViewSegue: NSStoryboardSegue {

    open var splitViewType: NSSplitViewItem.InitType = .standard
    
    // If true replace the source controller or last split view item
    // otherwise just append a new item
    open var replace = true

    open override func perform() {
        guard let fromController = self.sourceController as? NSViewController,
            let toController = self.destinationController as? NSViewController
            else { return }
        
        if let splitViewController = fromController.parent as? NSSplitViewController {
            if replace {
                if let splitViewItem = splitViewController.splitViewItem(for: fromController) {
                    splitViewController.removeSplitViewItem(splitViewItem)
                } else {
                    splitViewController.removeLastSplitViewItem()
                }
            }
            splitViewController.addViewController(toController, type: splitViewType)
        }
    }

    // In prepareForSegue of sourceController, store this segue into destinationController
    // Then you can call this method to dismiss the destinationController
    open func unperform() {
        guard let fromController = self.sourceController as? NSViewController,
            let toController = self.destinationController as? NSViewController
            else { return }
        
        if let splitViewController = toController.parent as? NSSplitViewController {
            if let splitViewItem = splitViewController.splitViewItem(for: toController) {
                splitViewController.removeSplitViewItem(splitViewItem)
            } else {
                splitViewController.removeLastSplitViewItem()
            }
            if replace {
                splitViewController.addViewController(fromController, type: splitViewType)
            }
        }
    }
    
}

// MARK: extension
public extension NSSplitViewController {
    
    public func addViewController(_ viewController: NSViewController, type: NSSplitViewItem.InitType = .standard) {
        self.addSplitViewItem(NSSplitViewItem(viewController: viewController, type: type))
    }
    
    public func removeLastSplitViewItem() {
        if let last = self.splitViewItems.last {
            self.removeSplitViewItem(last)
        }
    }
    
}

public extension NSSplitViewItem {
    
    public convenience init(viewController: NSViewController, type: NSSplitViewItem.InitType) {
        switch type {
        case .standard:
            self.init(viewController: viewController)
        case .sidebar:
            if #available(OSX 10.11, *) {
                self.init(sidebarWithViewController: viewController)
            } else {
                self.init(viewController: viewController)
            }
        case .contentList:
            if #available(OSX 10.11, *) {
                self.init(contentListWithViewController: viewController)
            } else {
                self.init(viewController: viewController)
            }
        }
    }
    
    public enum InitType {
        case standard
        @available(OSX 10.11, *)
        case sidebar
        @available(OSX 10.11, *)
        case contentList
    }
}

