//
//  SettingsViewController.swift
//  HeyMom
//
//  Created by Nien Lam on 4/17/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit
import Contacts

class SettingsViewController: UIViewController {

    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var frequencyButton: UIButton!
    @IBOutlet weak var momsPhoneNumberLabel: UILabel!
    
    // Get global singleton object.
    let appMgr = AppManager.sharedInstance
    
    var daySuffix: String {
        return (appMgr.dayCount > 1) ? "minutes" : "minute"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let contact = appMgr.momContact
        let phone = appMgr.momPhoneNumber
//        let localizedLabel = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: (phone?.label)!)
        
        let formattedNumber = phone?.value.stringValue.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
        
        phoneNumberButton.setTitle(formattedNumber, for: .normal)
        
        let frequencyString = "\(appMgr.dayCount) \(daySuffix)"
        frequencyButton.setTitle(frequencyString, for: .normal)
        
        if let name = appMgr.momContact?.givenName {
            momsPhoneNumberLabel.text = "\(name)'s phone number"
        }
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
