//
//  FromViewControllerswift
//  Example
//
//  Created by phimage on 24/07/16.
//  Copyright © 2016 phimage. All rights reserved.
//

import Cocoa
import CustomSegue

extension NSStoryboardSegue {
    var source: NSViewController? {
        return self.sourceController as? NSViewController
    }
    var destination: NSViewController? {
        return self.destinationController as? NSViewController
    }
}

class FromViewController: NSViewController {

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue == FromViewController.Segue.configured {
            if let segue = segue as? PresentWithAnimatorSegue, let animator = segue.animator as? TransitionAnimator {
                animator.duration = 1
                animator.transition = [.slideDown/*, .crossfade*/]
                animator.backgroundColor = NSColor(calibratedRed: 1, green: 0, blue: 0, alpha: 0.5)
                animator.keepOriginalSize = true
                animator.removeFromView = false

            }
        }
        else if segue.identifier == "chidwindow" {
            if let segue = segue as? ChildWindowSegue, let animator = segue.animator as? ChildWindowAnimator {
                animator.windowCustomizer = { window in
                    window.styleMask = .borderless
                 
                    if let frame = segue.source?.view.window?.frame {
                        // Open window near current one
                        let origin = NSPoint(x: frame.origin.x + frame.width, y: frame.origin.y)
                        window.setFrameOrigin(origin)
                    }
                }
            }
        }
        else if segue.identifier == "splitview" {
            if let segue = segue as? ChildWindowSegue, let animator = segue.animator as? ChildWindowAnimator {
                animator.windowCustomizer = { window in
                    
                    if let frame = segue.source?.view.window?.frame {
                        
                        var newFrame = NSRect()
                        newFrame.origin =  NSPoint(x: frame.origin.x + frame.width, y: frame.origin.y)
                        newFrame.size = NSSize(width: frame.width * 2, height: frame.height)
                        window.setFrame(newFrame, display: false)
                        
                        if let splitC = segue.destinationController as? NSSplitViewController {
                            splitC.splitView.setPosition(frame.width / 2, ofDividerAt: 0)
                        }
                    }
                }
                
              
            }
        }
        else if segue.identifier == "customanimator" {
            if let segue = segue as? PresentWithAnimatorSegue {
                if let frame = segue.source?.view.window?.frame {
                    segue.animator = CustomAnimator(duration: 1.0, rect: frame)
                }
                
            }
        } else if segue.identifier == "replace" {
            if let segue = segue as? ReplaceWindowContentSegue, let destinationController = segue.destinationController as? DestinationViewController {
                destinationController.segue = segue
            }
        }
    }

}

 
