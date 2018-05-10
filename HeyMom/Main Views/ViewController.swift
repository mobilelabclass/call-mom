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
    var callStartTime: CFAbsoluteTime!
    
    // Get global singleton object.
    let appMgr = AppManager.sharedInstance


    override func viewDidLoad() {
        super.viewDidLoad()


        // Load saved settings in user defaults.
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
        
        
        // Run onboarding flow only when first entering the app.
        if !appMgr.isOnboardingComplete {
            startOnboardingFlow()
        }


        // Initialize heart visualization.
        heartVizView.resetToFull()


        findContactsWithName(name: "mom")

        
        print(appMgr.callDateLog)
        print(appMgr.callDurationLog)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        resetHeartViz()
    }
  

    func callDidConnect() {
        callStartTime = CFAbsoluteTimeGetCurrent()
    }

    func callDidDisconnect() {
        let callDuration = Int(CFAbsoluteTimeGetCurrent() - callStartTime)

        if appMgr.isMinimumCallTime(callDuration) {
            appMgr.saveCallLog(date: Date(), duration: callDuration)
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
        resetHeartViz()
        
        if let sinceLastCall = appMgr.sinceLastCall {
            print("s:\(sinceLastCall.seconds) m:\(sinceLastCall.minutes) h:\(sinceLastCall.hours) d:\(sinceLastCall.days) ")
            
            titleLabel.text = "\(sinceLastCall.minutes) Minutes"
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                guard let strongSelf = self else { return }
                
                print("goal %: \(strongSelf.appMgr.goalPercentage)")
                
                strongSelf.heartVizView.animateTo(strongSelf.appMgr.goalPercentage)
            }
        }
    }
    
    @IBAction func testAnimation(_ sender: UIButton) {
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


