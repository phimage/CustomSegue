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
        else if segue.identifier == "chidwindow" {
            if let segue = segue as? ChildWindowSegue, animator = segue.animator as? ChildWindowAnimator {
                animator.windowCustomizer = { window in
                    window.styleMask = NSBorderlessWindowMask
                 
                    if let frame = segue.sourceController.view?.window?.frame {
                        // Open window near current one
                        let origin = NSPoint(x: frame.origin.x + frame.width, y: frame.origin.y)
                        window.setFrameOrigin(origin)
                    }
                }
            }
        }
        else if segue.identifier == "splitview" {
            if let segue = segue as? ChildWindowSegue, animator = segue.animator as? ChildWindowAnimator {
                animator.windowCustomizer = { window in
                    
                    if let frame = segue.sourceController.view?.window?.frame {
                        
                        var newFrame = NSRect()
                        newFrame.origin =  NSPoint(x: frame.origin.x + frame.width, y: frame.origin.y)
                        newFrame.size = NSSize(width: frame.width * 2, height: frame.height)
                        window.setFrame(newFrame, display: false)
                        
                        if let splitC = segue.destinationController as? NSSplitViewController {
                            splitC.splitView.setPosition(frame.width / 2, ofDividerAtIndex: 0)
                        }
                    }
                }
                
              
            }
        }
        else if segue.identifier == "customanimator" {
            if let segue = segue as? PresentWithAnimatorSegue {
                if let frame = segue.sourceController.view?.window?.frame {
                    segue.animator = CustomAnimator(duration: 1.0, rect: frame)
                }
                
            }
        } else if segue.identifier == "replace" {
            if let segue = segue as? ReplaceWindowContentSegue, destinationController = segue.destinationController as? DestinationViewController {
                destinationController.segue = segue
            }
        }
    }

}

 