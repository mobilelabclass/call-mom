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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func handleBackButton(_ sender: UIButton) {
        self.didGoBack?()
    }

    @IBAction func handleFinishButton(_ sender: UIButton) {
        self.didFinish?()
    }
}
