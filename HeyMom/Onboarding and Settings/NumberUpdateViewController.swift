//
//  NumberUpdateViewController.swift
//  HeyMom
//
//  Created by Nien Lam on 5/7/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit

class NumberUpdateViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    var didGoBack: (() -> ())?
    var didGoNext: (() -> ())?
    
    // Set to true if using VC from settings view.
    var isSettingsMode = false;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Buttons user only for onboarding flow.
        if isSettingsMode {
            backButton.isHidden = true
            nextButton.isHidden = true
        }
        

        //        numberTextField.text = appMgr.telephoneNumber?.absoluteString.replacingOccurrences(of: "tel://", with: "")
        //
        //        // Required for textfield delegate methods.
        //        numberTextField.delegate = self

    }

    @IBAction func handleBackButton(_ sender: UIButton) {
        self.didGoBack?()
    }
    
    @IBAction func handleNextButton(_ sender: UIButton) {
        self.didGoNext?()
    }
    
    
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //        appMgr.storeTelephoneNumber(textField.text!)
    //
    //        // Dismisses keyboard when done is pressed.
    //        view.endEditing(true)
    //        return false
    //    }
    

    
    
}
