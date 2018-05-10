//
//  CallLogTableViewController.swift
//  HeyMom
//
//  Created by Nien Lam on 5/10/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CallLogTableViewCell"

class CallLogTableViewController: UITableViewController {

    // Get global singleton object.
    let appMgr = AppManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appMgr.callDateLog.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CallLogTableViewCell
        
        let date = appMgr.callDateLog.reversed()[indexPath.row].description
        let duration = "\(appMgr.callDurationLog.reversed()[indexPath.row]) seconds"
        
        cell.callDateLabel.text     = date
        cell.callDurationLabel.text = duration

        return cell
    }

    @IBAction func handleCloseButton(_ sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
