//
//  CustomAnimator.swift
//  Example

import Cocoa

class CustomAnimator: NSObject, NSViewControllerPresentationAnimator {
    
    private let duration: NSTimeInterval
    private let rect: NSRect
    
    init(duration: NSTimeInterval, rect: NSRect) {
        self.duration = duration
        self.rect = rect
        super.init()
    }
    
    @objc func animatePresentationOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
        let parentVC = fromViewController
        let childVC = viewController
        childVC.view.wantsLayer = true
        childVC.view.layerContentsRedrawPolicy = .OnSetNeedsDisplay
        childVC.view.translatesAutoresizingMaskIntoConstraints = true
        childVC.view.alphaValue = 0
        let anotherRect = NSMakeRect(rect.minX, parentVC.view.frame.height - rect.minY, rect.width, rect.height)
        childVC.view.frame = anotherRect
        parentVC.view.addSubview(childVC.view)
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = self.duration
            childVC.view.animator().alphaValue = 1
            childVC.view.animator().frame = parentVC.view.frame
            }, completionHandler: {
                childVC.view.translatesAutoresizingMaskIntoConstraints = false
                let views = ["view" : childVC.view]
                let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: views)
                let verticalConstraints   = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: views)
                parentVC.view.addConstraints(horizontalConstraints)
                parentVC.view.addConstraints(verticalConstraints)
        })
    }
    
    @objc func animateDismissalOfViewController(viewController: NSViewController, fromViewController: NSViewController) {
        let childVC = viewController
        childVC.view.wantsLayer = true
        childVC.view.layerContentsRedrawPolicy = .OnSetNeedsDisplay
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = self.duration
            childVC.view.animator().alphaValue = 0
            }, completionHandler: {
                childVC.view.removeFromSuperview()
        })
    }
    
}