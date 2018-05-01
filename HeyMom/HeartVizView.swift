//
//  HeartVizView.swift
//  HeyMom
//
//  Created by Nien Lam on 5/1/18.
//  Copyright © 2018 Mobile Lab. All rights reserved.
//

import UIKit

class HeartVizView: UIView {

    let shapeLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        shapeLayer.path = UIBezierPath(heartIn: bounds).cgPath
        
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 20.0
        shapeLayer.lineCap = kCALineCapRound
//        shapeLayer.strokeEnd = 0
        
        layer.addSublayer(shapeLayer)
        
        animate()
    }

    func animate() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.fromValue = 0.0
        animation.byValue = 0.9
        animation.duration = 1.0
        
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        
        shapeLayer.add(animation, forKey: "drawLineAnimation")

    }
    
}

extension UIBezierPath {
    convenience init(heartIn rect: CGRect) {
        self.init()
        
        //Calculate Radius of Arcs using Pythagoras
        let sideOne = rect.width * 0.4
        let sideTwo = rect.height * 0.3
        let arcRadius = sqrt(sideOne*sideOne + sideTwo*sideTwo)/2
        
        //Left Hand Curve
        self.addArc(withCenter: CGPoint(x: rect.width * 0.3, y: rect.height * 0.35), radius: arcRadius, startAngle: 135.degreesToRadians, endAngle: 315.degreesToRadians, clockwise: true)
        
        //Top Centre Dip
        self.addLine(to: CGPoint(x: rect.width/2, y: rect.height * 0.2))
        
        //Right Hand Curve
        self.addArc(withCenter: CGPoint(x: rect.width * 0.7, y: rect.height * 0.35), radius: arcRadius, startAngle: 225.degreesToRadians, endAngle: 45.degreesToRadians, clockwise: true)
        
        //Right Bottom Line
        self.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.95))
        
        //Left Bottom Line
        self.close()
    }
}

extension Int {
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
}
