//
//  SplitViewController.swift
//  Example
//
//  Created by phimage on 21/08/16.
//  Copyright © 2016 phimage. All rights reserved.
//

import Cocoa
import CustomSegue

class SplitViewController: NSViewController {
    
    @IBOutlet weak var checkbox: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if let segue = segue as? SplitViewSegue {
            segue.replace = checkbox.state == NSOnState
            if let d = segue.destinationController as? DestinationSplitViewController {
                d.segue = segue
            }
        }
    }
}



class DestinationSplitViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!

    var segue: SplitViewSegue?
    
    @IBAction func dismissSegue(sender: AnyObject?) {
        segue?.unperform()
    }
    
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if let segue = segue as? TablePopoverSegue where segue.identifier == "rowdetail" {
            segue.popoverBehavior = .Transient
            segue.tableView = tableView
            
            // TIPS get selected object and pass info to the destination controller
            let selectedRow = tableView.selectedRow
            if (selectedRow >= 0) {
                
                
            }
        }
    }

}


extension DestinationSplitViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return 2
    }

    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return "\(row)"
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        self.performSegueWithIdentifier("rowdetail", sender: notification.object)
    }
}