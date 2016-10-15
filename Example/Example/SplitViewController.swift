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

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
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
    
    @IBAction func dismissSegue(_ sender: AnyObject?) {
        segue?.unperform()
    }
    
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let segue = segue as? TablePopoverSegue , segue.identifier == "rowdetail" {
            segue.popoverBehavior = .transient
            segue.tableView = tableView
            
            // TIPS get selected object and pass info to the destination controller
            let selectedRow = tableView.selectedRow
            if (selectedRow >= 0) {
                
                
            }
        }
    }

}


extension DestinationSplitViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 2
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return "\(row)"
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        self.performSegue(withIdentifier: "rowdetail", sender: notification.object)
    }
}
