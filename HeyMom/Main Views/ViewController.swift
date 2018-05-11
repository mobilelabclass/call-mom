//
//  ViewController.swift
//  HeyMom
//
//  Created by Nien Lam on 4/17/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var heartVizView: HeartVizView!
    
    // Contacts framework.
    var store = CNContactStore()
    var contacts: [CNContact] = []
    
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
        
        // Testing
        findContactsWithName(name: "mom")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Need to reset visualization of day count updated from settings.
        if currentDayCount != appMgr.dayCount {
            currentDayCount = appMgr.dayCount

            heartVizView.animateTo(1.0)
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

            self.animateHeartViz()
        }
    }
    
    // Onboarding flow setup.
    func startOnboardingFlow() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let onboardingPageVC = sb.instantiateViewController(withIdentifier: "OnboardingPageVC") as! OnboardingPageViewController
        
        view.addSubview(onboardingPageVC.view)
        addChildViewController(onboardingPageVC)
        
        onboardingPageVC.didFinishSetup = {
            UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseIn, animations: {
                onboardingPageVC.view.frame.origin = CGPoint(x: 0, y: onboardingPageVC.view.bounds.height)
            }, completion: { (finished) in
                onboardingPageVC.view.removeFromSuperview()
                onboardingPageVC.removeFromParentViewController()
            })
        }
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
        guard let sinceLastCall = appMgr.sinceLastCall else { return }

        print("s:\(sinceLastCall.seconds) m:\(sinceLastCall.minutes) h:\(sinceLastCall.hours) d:\(sinceLastCall.days) ")
        
        titleLabel.text = "\(sinceLastCall.minutes) Minutes"
        
        // Hide or show label if there is call history.
        subtitleLabel.isHidden = appMgr.sinceLastCall == nil ? true : false

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            guard let strongSelf = self else { return }
            
            print("goal %: \(strongSelf.appMgr.goalPercentage)")
            
            strongSelf.heartVizView.animateTo(strongSelf.appMgr.goalPercentage)
        }
    }
    
    func timeStamp(date: Date) -> String {
        return DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)
    }
    
    func findContactsWithName(name: String) {
        checkAccessStatus(completionHandler: { (accessGranted) -> Void in
            if accessGranted {
                DispatchQueue.main.async {
                    do {
                        let predicate: NSPredicate = CNContact.predicateForContacts(matchingName: name)
                        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
                        self.contacts = try self.store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
                        if let contact = self.contacts.first {
                            let givenName = contact.givenName
                            let familyName = contact.familyName
                            for phoneNumber in contact.phoneNumbers {
                                let number = phoneNumber.value as CNPhoneNumber
                                let label = phoneNumber.label
                                let localizedLabel = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label!)
                                print("\(givenName) - \(familyName) - \(localizedLabel) - \(number.stringValue)")
                            }
                        }
                    }
                    catch {
                        print("Unable to refetch the selected contact.")
                    }
                }
            }
        })
    }
    
    func checkAccessStatus(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
        case .denied, .notDetermined:
            self.store.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                }
                else {
                    print("access denied")
                }
            })
        default:
            completionHandler(false)
        }
    }

}


