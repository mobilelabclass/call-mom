//
//  ViewController.swift
//  CallMom
//
//  Created by Nien Lam on 4/17/18.
//  Copyright © 2018 Mobile Lab. All rights reserved.
//

import UIKit
import Lottie

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var callDateLabel: UILabel!
    @IBOutlet weak var callDurationLabel: UILabel!

    // Track call time.
    var callTime: CFAbsoluteTime!
    
    // Get global singleton object.
    let appMgr = AppManager.sharedInstance

    var animationView: LOTAnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()

        appMgr.callStateChanged = { callState in
            switch callState as CallState {
                case .Disconnected:
                    print("currentCallState: Disconnected")
                    let elapsed: Int = Int(CFAbsoluteTimeGetCurrent() - self.callTime)
                    self.callDurationLabel.text = "CallTime: \(elapsed) seconds"
                    self.callDateLabel.text = self.timeStamp()
                
                case .Dialing:
                    print("currentCallState: Dialing")

                case .Incoming:
                    print("currentCallState: Incoming)")

                case .Connected:
                    print("currentCallState: Connected")
                    self.callTime = CFAbsoluteTimeGetCurrent()
            }
        }


        animationView = LOTAnimationView(name: "TwitterHeart")
        animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        animationView.contentMode = .scaleAspectFill
        animationView.frame = view.bounds
        //        animationView.backgroundColor = UIColor.red
        self.view.insertSubview(animationView, at: 0)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.delegate = self
        animationView.addGestureRecognizer(tap)


    }

    @objc
    func handleTap(sender: UITapGestureRecognizer) {
        animationView.play{ (finished) in
        }
    }
    
    
    // Make call with button press
    @IBAction func handleCallButton(_ sender: UIButton) {
        if let number = appMgr.telephoneNumber {
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
        }
    }
    
    func timeStamp() -> String {
        return DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short)
    }

}


