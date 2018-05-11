//
//  ViewController.swift
//  HeyMom
//
//  Created by Nien Lam on 4/17/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var heartVizView: HeartVizView!
    
    // Track call time.
    var callStartTime: Date?

    // Track frequency day count.
    var currentDayCount = 0
    
    // Get global singleton object.
    let appMgr = AppManager.sharedInstance

    private var fgAppNotification: NSObjectProtocol?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Load app settings
        appMgr.loadDefaults()

        // Handle call state changes.
        appMgr.callStateChanged = { callState in
            switch callState as CallState {
                case .Disconnected:
                    print("currentCallState: Disconnected")
                    self.callDidDisconnect()
                
                case .Dialing:
                    print("currentCallState: Dialing")

                case .Incoming:
                    print("currentCallState: Incoming)")

                case .Connected:
                    print("currentCallState: Connected")
                    self.callDidConnect()
            }
        }
        
        // Initialize heart visualization and animate.
        resetHeartViz()
        animateHeartViz()

        // Save current day count.
        currentDayCount = appMgr.dayCount
        
        // Run animation when app enters the forground.
        fgAppNotification = NotificationCenter.default.addObserver(forName: .UIApplicationWillEnterForeground,
                                                                   object: nil,
                                                                   queue: .main)
        { [weak self] (notification) in
            self?.resetHeartViz()
            self?.animateHeartViz()
        }

        // Run onboarding flow only when first entering the app.
        if !appMgr.isOnboardingComplete {
            startOnboardingFlow()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Need to reset visualization of day count updated from settings.
        if currentDayCount != appMgr.dayCount {
            currentDayCount = appMgr.dayCount

            self.animateHeartViz()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
  
    deinit {
        if let notification = fgAppNotification {
            NotificationCenter.default.removeObserver(notification)
        }
    }
        
    func callDidConnect() {
        callStartTime = Date()
    }

    func callDidDisconnect() {
        guard let startTime = self.callStartTime else { return }

        // Save call start time and duration if minimum time reached.
        let duration = Int(Date().timeIntervalSince(startTime))
        if appMgr.isMinimumCallTime(duration) {
            appMgr.saveCallLog(date: startTime, duration: duration)

            appMgr.resetReminder()
            
            // Refill heart after making a call.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) { [weak self] in
                self?.animateHeartViz()
            }
        } else {
            let alert = UIAlertController(title: "Call too short!", message: "Talk to your Mom longer next time.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    // Onboarding flow setup.
    func startOnboardingFlow() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let onboardingPageVC = sb.instantiateViewController(withIdentifier: "OnboardingPageVC") as! OnboardingPageViewController
        
        view.addSubview(onboardingPageVC.view)
        addChildViewController(onboardingPageVC)
        
        onboardingPageVC.didFinishSetup = {
            UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseIn, animations: { [weak self] in
                onboardingPageVC.view.frame.origin = CGPoint(x: 0, y: onboardingPageVC.view.bounds.height)
                self?.resetHeartViz()

            }, completion: { [weak self](finished) in
                onboardingPageVC.view.removeFromSuperview()
                onboardingPageVC.removeFromParentViewController()
                
                self?.animateHeartViz()
            })
        }
    }
    
    // TESTING ONBOARDING FLOW
    @IBAction func handleOnboarding(_ sender: UIButton) {
        appMgr.dayCount = 5
        appMgr.momPhoneNumber = nil
        startOnboardingFlow()
    }
    
    // Make call with button press
    @IBAction func handleCallButton(_ sender: UIButton) {
        if let numberURL = appMgr.momPhoneNumberURL {
            UIApplication.shared.open(numberURL, options: [:], completionHandler: nil)
        }
    }
    
    func resetHeartViz() {
        // Initialize heart visualization.
        heartVizView.resetToFull()
    }
    
    func animateHeartViz() {
        if let sinceLastCall = appMgr.sinceLastCall {

            // Format time for title.
            var timeSinceLastCall = 0
            var unitTime = ""

            if sinceLastCall.days > 0 {
                timeSinceLastCall = sinceLastCall.days
                unitTime = sinceLastCall.days == 1 ? "Day" : "Days"
            } else if sinceLastCall.hours > 0 {
                timeSinceLastCall = sinceLastCall.hours
                unitTime = sinceLastCall.hours == 1 ? "Hour" : "Hours"
            } else  {
                timeSinceLastCall = sinceLastCall.minutes
                unitTime = sinceLastCall.minutes == 1 ? "Minute" : "Minutes"
            }
            
            titleLabel.text = "\(timeSinceLastCall) \(unitTime)"
            
            subtitleLabel.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.heartVizView.animateTo(strongSelf.appMgr.goalPercentage)
            }
        } else {
            subtitleLabel.isHidden = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.heartVizView.animateTo(0)
            }
        }

    }
    
    func timeStamp(date: Date) -> String {
        return DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)
    }
}


