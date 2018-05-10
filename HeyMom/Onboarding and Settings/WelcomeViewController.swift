//
//  WelcomeViewController.swift
//  HeyMom
//
//  Created by Nien Lam on 5/7/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var waveImageView: UIImageView!
    
    var didGoNext: (() -> ())?
    
    let wave0 = UIImage(named: "wave0")!
    let wave1 = UIImage(named: "wave1")!
    let wave2 = UIImage(named: "wave2")!
    let wave3 = UIImage(named: "wave3")!
    let wave4 = UIImage(named: "wave4")!
    let wave5 = UIImage(named: "wave5")!
    let wave6 = UIImage(named: "wave6")!
    let wave7 = UIImage(named: "wave7")!
    let wave8 = UIImage(named: "wave8")!
    let wave9 = UIImage(named: "wave9")!
    let wave10 = UIImage(named: "wave10")!
    let wave11 = UIImage(named: "wave11")!
    let wave12 = UIImage(named: "wave12")!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let seq = [
            wave0,
            wave1,
            wave2,
            wave3,
            wave4,
            wave5,
            wave6,
            wave7,
            wave8,
            wave9,
            wave10,
            wave11,
            wave12,
            wave11,
            wave10,
            wave9,
            wave8,
            wave7,
            wave6,
            wave5,
            wave4,
            wave3,
            wave2,
            wave1
        ]
        
        waveImageView.image = UIImage.animatedImage(with: seq, duration: 0.5)
    }
    
    @IBAction func handleNextButton(_ sender: UIButton) {
        self.didGoNext?()
    }
}

