//
//  FrequencyUpdateViewController.swift
//  HeyMom
//
//  Created by Nien Lam on 5/7/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit

class FrequencyUpdateViewController: UIViewController {

    var didConfirm: (() -> ())?
    var didCancel: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func handleConfirmButton(_ sender: UIButton) {
        self.didConfirm?()
    }

    @IBAction func handleCancelButton(_ sender: UIButton) {
        self.didCancel?()
    }
    
}
