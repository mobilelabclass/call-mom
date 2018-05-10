//
//  FinishSetupViewController.swift
//  HeyMom
//
//  Created by Nien Lam on 5/7/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit

class FinishSetupViewController: UIViewController {

    var didGoBack: (() -> ())?
    var didFinish: (() -> ())?
    
    // Get global singleton object.
    let appMgr = AppManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func handleBackButton(_ sender: UIButton) {
        self.didGoBack?()
    }

    @IBAction func handleFinishButton(_ sender: UIButton) {
        // Set onboarding complete flag.
        appMgr.isOnboardingComplete = true
        
        self.didFinish?()
    }
}
