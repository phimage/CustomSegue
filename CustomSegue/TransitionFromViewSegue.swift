//
//  TransitionFromViewSegue.swift
//  CustomSegue
//
//  Created by phimage on 19/08/16.
//  Copyright © 2016 phimage. All rights reserved.
//

import AppKit

// Segue using parent controller of source and `transitionFromViewController`
public class TransitionFromViewSegue: NSStoryboardSegue {
    
    // Animation options for view transitions
    public var transition: NSViewControllerTransitionOptions =  [.Crossfade, .SlideDown]
    // Handler for transition completion
    public var completionHandler: (() -> Void)?
    // Set wants layer or not for all controller main view
    public var wantsLayer = true
    
    override public func perform() {
        guard let fromController = self.sourceController as? NSViewController,
            let toController = self.destinationController as? NSViewController
            else { return }

        if let parentViewController = fromController.parentViewController {
            parentViewController.addChildViewController(toController)

            if wantsLayer {
                parentViewController.view.wantsLayer = true
                fromController.view.wantsLayer = true
                toController.view.wantsLayer = true
            }

            parentViewController.transitionFromViewController(fromController, toViewController: toController, options: transition, completionHandler: completionHandler)
        }
    }
    
}