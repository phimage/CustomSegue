//
//  FromViewControllerswift
//  Example
//
//  Created by phimage on 24/07/16.
//  Copyright © 2016 phimage. All rights reserved.
//

import Cocoa
import CustomSegue

class FromViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "configured" {
            if let segue = segue as? PresentWithAnimatorSegue, animator = segue.animator as? TransitionAnimator {
                
                animator.duration = 1
                animator.transition = [.SlideDown/*, .Crossfade*/]
                animator.backgroundColor = NSColor(calibratedRed: 1, green: 0, blue: 0, alpha: 0.5)
                animator.keepOriginalSize = true
                animator.removeFromView = false
            }
        }
    }


}

