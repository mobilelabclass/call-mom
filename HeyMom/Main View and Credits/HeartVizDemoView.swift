//
//  HeartVizDemoView.swift
//  HeyMom
//
//  Created by Sebastian Buys on 5/9/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit

class HeartVizDemoView: UIView {
    
    private let shapeLayer = CAShapeLayer()
    private let silhouetteLayer = CAShapeLayer()
    
    private let lineWidth: CGFloat = 30.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Silhouette Layer
        let s = heartPath
        s.bezierPath.scaleAroundCenter(factor: 0.5)
        
        silhouetteLayer.frame = CGRect(x: (bounds.width - s.canvasWidth) / 2.0,
                                       y: (bounds.height - s.canvasHeight) / 2.0,
                                       width: s.canvasWidth,
                                       height: s.canvasHeight)
        silhouetteLayer.path        = s.bezierPath.cgPath
        silhouetteLayer.strokeColor = UIColor.black.withAlphaComponent(0.2).cgColor
        silhouetteLayer.fillColor   = UIColor.clear.cgColor
        silhouetteLayer.lineWidth   = lineWidth
        silhouetteLayer.lineCap     = kCALineCapRound
        silhouetteLayer.lineJoin    = kCALineJoinRound
        layer.addSublayer(silhouetteLayer)
        
        // Heart Shape Layer
        let h = heartPath
        h.bezierPath.scaleAroundCenter(factor: 0.5)
        
        shapeLayer.frame = CGRect(x: (bounds.width - h.canvasWidth) / 2.0,
                                  y: (bounds.height - h.canvasHeight) / 2.0,
                                  width: h.canvasWidth,
                                  height: h.canvasHeight)
        shapeLayer.path        = h.bezierPath.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor   = UIColor.clear.cgColor
        shapeLayer.lineWidth   = lineWidth
        shapeLayer.lineCap     = kCALineCapRound
        shapeLayer.lineJoin    = kCALineJoinRound
        layer.addSublayer(shapeLayer)
    }
    
    // Sets heart to full.
    func resetToFull() {
        shapeLayer.removeAllAnimations()
        shapeLayer.strokeEnd = 1.0
    }
    
    // Animate heart to percentage full.
    func animateTo(_ toValue: CGFloat, speed: Double, onComplete: (() -> Void)? ) {
        shapeLayer.removeAllAnimations()
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.duration = speed
        
        animation.fromValue = shapeLayer.presentation()?.strokeEnd
        animation.toValue = toValue
        
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(onComplete)
        shapeLayer.add(animation, forKey: "strokeEnd")
        CATransaction.commit()
    }
    
    // Using PaintCode to generate path.
    var heartPath: (canvasWidth: CGFloat, canvasHeight: CGFloat, bezierPath: UIBezierPath) {
        let canvasWidth: CGFloat = 500
        let canvasHeight: CGFloat = 400
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 249.5, y: 376.5))
        bezierPath.addCurve(to: CGPoint(x: 166.58, y: 333.94), controlPoint1: CGPoint(x: 249.5, y: 376.5), controlPoint2: CGPoint(x: 221.5, y: 370.24))
        bezierPath.addCurve(to: CGPoint(x: 66.42, y: 245.94), controlPoint1: CGPoint(x: 111.65, y: 297.64), controlPoint2: CGPoint(x: 94.78, y: 279.67))
        bezierPath.addCurve(to: CGPoint(x: 25.5, y: 140.28), controlPoint1: CGPoint(x: 38.06, y: 212.2), controlPoint2: CGPoint(x: 25.5, y: 171.57))
        bezierPath.addCurve(to: CGPoint(x: 146.12, y: 24.5), controlPoint1: CGPoint(x: 25.5, y: 67.74), controlPoint2: CGPoint(x: 77.15, y: 24.5))
        bezierPath.addCurve(to: CGPoint(x: 249.5, y: 77.3), controlPoint1: CGPoint(x: 185.53, y: 24.5), controlPoint2: CGPoint(x: 228.33, y: 42.1))
        bezierPath.addCurve(to: CGPoint(x: 352.88, y: 24.5), controlPoint1: CGPoint(x: 270.67, y: 42.1), controlPoint2: CGPoint(x: 313.47, y: 24.5))
        bezierPath.addCurve(to: CGPoint(x: 473.5, y: 140.28), controlPoint1: CGPoint(x: 421.85, y: 24.5), controlPoint2: CGPoint(x: 473.5, y: 67.74))
        bezierPath.addCurve(to: CGPoint(x: 432.58, y: 245.94), controlPoint1: CGPoint(x: 473.5, y: 171.57), controlPoint2: CGPoint(x: 460.94, y: 212.2))
        bezierPath.addCurve(to: CGPoint(x: 332.42, y: 333.94), controlPoint1: CGPoint(x: 404.22, y: 279.67), controlPoint2: CGPoint(x: 387.35, y: 297.64))
        bezierPath.addCurve(to: CGPoint(x: 249.5, y: 376.5), controlPoint1: CGPoint(x: 277.5, y: 370.24), controlPoint2: CGPoint(x: 249.5, y: 376.5))
        bezierPath.close()
        
        return (canvasWidth, canvasHeight, bezierPath)
    }
    
    // For debugging.
    var ringPath: UIBezierPath {
        let bezierPath = UIBezierPath()
        let arcCenter = CGPoint(x: 185, y: 110)
        bezierPath.addArc(withCenter: arcCenter, radius: 50.0, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        return bezierPath
    }
}
