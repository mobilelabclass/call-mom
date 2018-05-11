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
    
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup date formatter.
        dateFormatter.locale     = Locale(identifier: "en_US_POSIX")
        // dateFormatter.dateFormat = "EEEE h:mm a 'on' MMMM dd, yyyy"
        dateFormatter.dateFormat = "MM-dd"
        dateFormatter.amSymbol   = "AM"
        dateFormatter.pmSymbol   = "PM"
        
        // Setup date formatter.
        timeFormatter.locale     = Locale(identifier: "en_US_POSIX")
        // dateFormatter.dateFormat = "EEEE h:mm a 'on' MMMM dd, yyyy"
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.amSymbol   = "AM"
        timeFormatter.pmSymbol   = "PM"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appMgr.callDateLog.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CallLogTableViewCell
        
        let date     = appMgr.callDateLog.reversed()[indexPath.row]
        // let duration = "\(appMgr.callDurationLog.reversed()[indexPath.row]) seconds"
        
        let seconds = appMgr.callDurationLog.reversed()[indexPath.row]
        
        let max = appMgr.callDurationLog.max()
        
        let maxSafe = max == nil ? 0 : max!;
        
        let pct = Float(seconds) / Float(maxSafe)
        
        
        let secondsF = Float(seconds)
        let hours = floor(secondsF / (60.0 * 60.0))
        let minutesAsSeconds = secondsF - hours * 60.0
        let minutes = floor(minutesAsSeconds / 60.0)
        
        let hoursI =  Int(hours)
        let minutesI = Int(minutes)
        let secondsRemainder = seconds - (hoursI * 60 * 60) - (minutesI * 60)
        
        let hoursFormatted = hoursI < 10 ? "0\(hoursI)" : "\(hoursI)"
        let minutesFormatted = minutesI < 10 ? "0\(minutesI)" : "\(minutesI)"
        let secondsFormatted = secondsRemainder < 10 ? "0\(secondsRemainder)" : "\(secondsRemainder)"
        
        cell.callDateLabel.text     =  dateFormatter.string(from: date)
        
        cell.callTimeLabel.text = timeFormatter.string(from: date)
        
        cell.callDurationLabel.text = "\(hoursFormatted):\(minutesFormatted):\(secondsFormatted)"
        
        cell.heartGraphic.alpha = CGFloat(pct)
        
        // cell.callDurationLabel.text = duration

        return cell
    }

    @IBAction func handleCloseButton(_ sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
