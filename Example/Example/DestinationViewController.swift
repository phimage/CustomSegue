//
//  DestinationViewController.swift
//  Example
//
//  Created by phimage on 24/07/16.
//  Copyright © 2016 phimage. All rights reserved.
//

import Cocoa

class DestinationViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Dismiss after defined time interval
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(DestinationViewController.dismissController(_:)), userInfo: nil, repeats: false)
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }

}

class DestinationView: NSView {
    override func mouseDown(theEvent: NSEvent) {
        // Prevent to pass event to source controller views
    }

    override func acceptsFirstMouse(theEvent: NSEvent?) -> Bool {
        return true
    }
}
