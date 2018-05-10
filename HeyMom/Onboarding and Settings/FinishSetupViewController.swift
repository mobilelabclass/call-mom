//
//  FinishSetupViewController.swift
//  HeyMom
//
//  Created by Nien Lam on 5/7/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit
import pop

enum HeyMomAnimationKeys: String {
    case shake = "heymom_animation_shake"
}

enum FinishSequenceState {
    case ready
    case step1Begin // heart
    case step1Finish
    case step2Begin // call
    case step2Finish // finish
}

class FinishSetupViewController: UIViewController {
    
    @IBOutlet weak var heartVizDemo: HeartVizDemoView!
    
    @IBOutlet weak var step1Label: UILabel!
    @IBOutlet weak var step2Label: UILabel!
    
    @IBOutlet weak var fakePhoneButton: UIView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var didGoBack: (() -> ())?
    var didFinish: (() -> ())?
    
    private var state = FinishSequenceState.step1Begin {
        didSet {
            self.stateDidUpdate()
        }
    }
    
    // Haptic feedback
    var feedbackGenerator = UISelectionFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style phone button
        fakePhoneButton.layer.cornerRadius = fakePhoneButton.bounds.width / 2.0
        fakePhoneButton.clipsToBounds = true
    }
    
    func resetDemo() {
        state = .ready
    }
    
    func stateDidUpdate() {
        switch state {
        case .ready:
            self.nextButton.isEnabled = false
            heartVizDemo.resetToFull()
            fakePhoneButton.alpha = 0.0
            step1Label.alpha = 1.0
            step2Label.alpha = 0.0
        case .step1Begin:
            self.nextButton.isEnabled = false
            return
        case .step1Finish:
            self.nextButton.isEnabled = true
            return
        case .step2Begin:
            self.nextButton.isEnabled = false
            self.playStep2()
            return
        case .step2Finish:
            self.nextButton.isEnabled = true
            return
        }
    }
    
    func playStep1() {
        // First play the heart animation
        heartVizDemo.animateTo(0.1, speed: 2.0) { [weak self] in
            self?.state = .step1Finish
        }
    }
    
    func playStep2() {
//        UIView.animate(withDuration: 0.5, animations: { [weak self] in
//            self?.fakePhoneButton.alpha = 1.0
//        }, completion: { _ in
//        })
//
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.step2Label.alpha = 1.0
            self?.step1Label.alpha = 0.0
            self?.fakePhoneButton.alpha = 1.0
            }, completion: { _ in
        })
        
        feedbackGenerator.prepare()
        feedbackGenerator.selectionChanged()
        
        
        self.shakeButton(speed: 4.0, onCompletion: { [weak self] (animation, finished) in
            // self?.state = .step2Finish
        })
        
        heartVizDemo.animateTo(1.0, speed: 2.0) { [weak self] in
            self?.state = .step2Finish
        }
    }
    
    func shakeButton(speed: Float, onCompletion: ((POPAnimation?, Bool) -> Void)?) {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        animation?.velocity = CGPoint(x: 20.0, y: 20.0)
        animation?.springBounciness = CGFloat(20.0)
        
        let fr = CGFloat(1.0)
        let to = CGFloat(1.25)
        animation?.fromValue = CGPoint(x: fr, y: fr)
        animation?.toValue = CGPoint(x: to, y: to)
        // animation?.repeatCount = 2
        // animation?.autoreverses = true
        
        if let block = onCompletion {
            animation?.completionBlock = block
        }
        
        self.fakePhoneButton.pop_add(animation, forKey: HeyMomAnimationKeys.shake.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetDemo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        self.playStep1()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.resetDemo()
    }

    @IBAction func handleBackButton(_ sender: UIButton) {
        self.didGoBack?()
    }

    @IBAction func handleFinishButton(_ sender: UIButton) {
        if (self.state == .step1Finish) {
            self.state = .step2Begin
        }
        
        if (self.state == .step2Finish) {
            self.didFinish?()
        }
    }
}
