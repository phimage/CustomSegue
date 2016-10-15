//
//  CustomAnimator.swift
//  Example

import Cocoa

class CustomAnimator: NSObject, NSViewControllerPresentationAnimator {
    
    fileprivate let duration: TimeInterval
    fileprivate let rect: NSRect
    
    init(duration: TimeInterval, rect: NSRect) {
        self.duration = duration
        self.rect = rect
        super.init()
    }
    
    @objc func animatePresentation(of viewController: NSViewController, from fromViewController: NSViewController) {
        let parentVC = fromViewController
        let childVC = viewController
        childVC.view.wantsLayer = true
        childVC.view.layerContentsRedrawPolicy = .onSetNeedsDisplay
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
                let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: views)
                let verticalConstraints   = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: views)
                parentVC.view.addConstraints(horizontalConstraints)
                parentVC.view.addConstraints(verticalConstraints)
        })
    }
    
    @objc func animateDismissal(of viewController: NSViewController, from fromViewController: NSViewController) {
        let childVC = viewController
        childVC.view.wantsLayer = true
        childVC.view.layerContentsRedrawPolicy = .onSetNeedsDisplay
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = self.duration
            childVC.view.animator().alphaValue = 0
            }, completionHandler: {
                childVC.view.removeFromSuperview()
        })
    }
    
}
