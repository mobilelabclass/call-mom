//
//  CreditsViewController.swift
//  HeyMom
//
//  Created by Nien Lam on 5/9/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {

    @IBOutlet weak var momImageView: UIImageView!
    
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
        self.makeParticles()
        
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
        
        momImageView.image = UIImage.animatedImage(with: seq, duration: 0.5)
    }

    @IBAction func handleCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleLBLink(_ sender: UIButton) {
        let url = URL(string: "http://www.linebreak.studio")!

        let alert = UIAlertController(title: "Open Safari?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (action) in
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })

        self.present(alert, animated: true, completion: nil)
    }
    
    func makeParticles() {
        let particleEmitter = CAEmitterLayer()
        
        particleEmitter.emitterPosition = CGPoint(x: view.center.x, y: 0)
        particleEmitter.emitterShape = kCAEmitterLayerLine
        particleEmitter.emitterSize = CGSize(width: view.frame.width, height: 1)
        
        let cell = makeEmitterCell()
        
        particleEmitter.emitterCells = [cell]
        
        view.layer.addSublayer(particleEmitter)
    }
    
    func makeEmitterCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 4
        cell.lifetime = 10.0
        cell.lifetimeRange = 0
        cell.velocity = 200
        cell.velocityRange = 20
        cell.emissionRange = CGFloat.pi * 2
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 4
        cell.spin = 2
        cell.spinRange = 3
        // cell.scaleRange = 0.2
        // cell.scaleSpeed = -0.05
        cell.scale = 0.5
        
        cell.contents = UIImage(named: "small_heart")?.cgImage
        return cell
    }
}
