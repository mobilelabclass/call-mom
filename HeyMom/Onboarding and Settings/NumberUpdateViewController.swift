//
//  NumberUpdateViewController.swift
//  HeyMom
//
//  Created by Nien Lam on 5/7/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit

class NumberUpdateViewController: UIViewController {

    var didConfirm: (() -> ())?
    var didCancel: (() -> ())?

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func handleConfirmButton(_ sender: UIButton) {
        self.didConfirm?()
    }
    
    @IBAction func handleCanelButton(_ sender: UIButton) {
        self.didCancel?()
    }
    
}
