//
//  FrequencyUpdateViewController.swift
//  HeyMom
//
//  Created by Nien Lam on 5/7/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit

class FrequencyUpdateViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var dayCountLabel: UILabel!

    var didGoBack: (() -> ())?
    var didGoNext: (() -> ())?
    
    // Set to true if using VC from settings view.
    var isSettingsMode = false;
    
    var dayCount: Int = 5
    
    var daySuffix: String {
        return (dayCount > 1) ? "days" : "day"
    }

    // Get global singleton object.
    let appMgr = AppManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Buttons user only for onboarding flow.
        if isSettingsMode {
            backButton.isHidden = true
            nextButton.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Store day count on view exit.
        appMgr.storeDayCount(dayCount)
    }

    @IBAction func handleBackButton(_ sender: UIButton) {
        self.didGoBack?()
    }

    @IBAction func handleNextButton(_ sender: UIButton) {
        self.didGoNext?()
    }

    @IBAction func handleSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        dayCount = max(1, dayCount - 1)
        
        dayCountLabel.text = "\(dayCount) \(daySuffix)"
    }
    
    @IBAction func handleSwipeRight(_ sender: UISwipeGestureRecognizer) {
        dayCount = min(30, dayCount + 1)

        dayCountLabel.text = "\(dayCount) \(daySuffix)"
    }
}
