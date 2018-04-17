//
//  SettingsViewController.swift
//  CallMom
//
//  Created by Nien Lam on 4/17/18.
//  Copyright © 2018 Mobile Lab. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var numberTextField: UITextField!

    // Get global singleton object.
    let appMgr = AppManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        numberTextField.text = appMgr.telephoneNumber?.absoluteString.replacingOccurrences(of: "tel://", with: "")
        
        // Required for textfield delegate methods.
        numberTextField.delegate = self
    }
    
    @IBAction func handleDoneButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        appMgr.storeTelephoneNumber(textField.text!)
        
        // Dismisses keyboard when done is pressed.
        view.endEditing(true)
        return false
    }
    
}
