//
//  WelcomeViewController.swift
//  HeyMom
//
//  Created by Nien Lam on 5/7/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var heartVizView: HeartVizView!

    var didGoNext: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

        heartVizView.reverseAnimation()
    }
    
    @IBAction func handleNextButton(_ sender: UIButton) {
        self.didGoNext?()
    }
}
