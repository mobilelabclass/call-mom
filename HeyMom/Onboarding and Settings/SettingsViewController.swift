//
//  SettingsViewController.swift
//  HeyMom
//
//  Created by Nien Lam on 4/17/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // Get global singleton object.
    let appMgr = AppManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func handleDoneButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NumberUpdateSeque" {
            if let destinationVC = segue.destination as? NumberUpdateViewController {
                destinationVC.isSettingsMode = true
            }
        } else if segue.identifier == "FrequencyUpdateSeque" {
            if let destinationVC = segue.destination as? FrequencyUpdateViewController {
                destinationVC.isSettingsMode = true
            }
        }
    }
    

}
