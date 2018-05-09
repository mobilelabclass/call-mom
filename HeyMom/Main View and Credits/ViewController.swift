//
//  ViewController.swift
//  HeyMom
//
//  Created by Nien Lam on 4/17/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit
import Contacts
import UserNotifications


class ViewController: UIViewController, UIGestureRecognizerDelegate, UNUserNotificationCenterDelegate {

    @IBOutlet weak var callDateLabel: UILabel!
    @IBOutlet weak var callDurationLabel: UILabel!
    @IBOutlet weak var heartVizView: HeartVizView!

    var store = CNContactStore()
    var contacts: [CNContact] = []
    
    // Track call time.
    var callTime: CFAbsoluteTime!
    
    // Get global singleton object.
    let appMgr = AppManager.sharedInstance


    var aToggle = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appMgr.callStateChanged = { callState in
            switch callState as CallState {
                case .Disconnected:
                    print("currentCallState: Disconnected")
                    let elapsed: Int = Int(CFAbsoluteTimeGetCurrent() - self.callTime)
                    self.callDurationLabel.text = "CallTime: \(elapsed) seconds"
                    self.callDateLabel.text = self.timeStamp()
                
                    if elapsed > 5 {
                        self.appMgr.lastCallDuration = elapsed
                        self.appMgr.lastCallDate = Date()
                    }
                
                case .Dialing:
                    print("currentCallState: Dialing")

                case .Incoming:
                    print("currentCallState: Incoming)")

                case .Connected:
                    print("currentCallState: Connected")
                    self.callTime = CFAbsoluteTimeGetCurrent()
            }
        }
        


        let sb = UIStoryboard(name: "Main", bundle: nil)
        let onboardingPageVC = sb.instantiateViewController(withIdentifier: "OnboardingPageVC") as! OnboardingPageViewController

        self.view.addSubview(onboardingPageVC.view)
        self.addChildViewController(onboardingPageVC)

        onboardingPageVC.didFinishSetup = {
            UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseIn, animations: {
                onboardingPageVC.view.frame.origin = CGPoint(x: 0, y: onboardingPageVC.view.bounds.height)
            }, completion: { (finished) in
                onboardingPageVC.view.removeFromSuperview()
                onboardingPageVC.removeFromParentViewController()
            })
        }

        self.heartVizView.shapeLayer.removeAllAnimations()
        self.heartVizView.shapeLayer.strokeEnd = 1.0

        //requesting for authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            
        })
        findContactsWithName(name: "mom")
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        heartVizView.lineAnimation()

//        self?.heartVizView.reverseAnimation()

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.heartVizView.reverseAnimation()
        }
        

        
//        if let lastCallDate = self.appMgr.lastCallDate {
//
//            print(lastCallDate)
//            let sinceLastCall =  Date().timeIntervalSince(lastCallDate)
//            print(sinceLastCall)
//
//            print(">>>>>>>>>>>>>>>> \(sinceLastCall)")
//
//            heartVizView.reverseAnimation()
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        heartVizView.shapeLayer.removeAllAnimations()
        heartVizView.shapeLayer.strokeEnd = 1.0
    }
    

    /*
    @IBAction func settingsButton(_ sender: UIButton) {
//        aToggle = !aToggle
//
//        if aToggle {
//            heartVizView.reverseAnimation()
//        } else {
//            heartVizView.lineAnimation()
//        }

    }

 */
  
    // Make call with button press
    @IBAction func handleCallButton(_ sender: UIButton) {
        if let number = appMgr.telephoneNumber {
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
        }
    }
    
    func timeStamp() -> String {
        return DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //displaying the ios local notification when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }

    
    @IBAction func handleTestNotification(_ sender: UIButton) {
         //creating the notification content
         let content = UNMutableNotificationContent()
         
         //adding title, subtitle, body and badge
         content.title = "Reminder to call your mom"
         //        content.subtitle = ""
         content.body = "It's been 5 days since you called"
         content.sound = UNNotificationSound.default()
         content.badge = 0
         
         
         //        let alertDays = 3
         //        let daySeconds = 86400
         //        let alertSeconds = Double(alertDays * daySeconds)
         
         
//         let alertSeconds = Double(1 * 60)
        
         
         let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
         
         //getting the notification request
         let request = UNNotificationRequest(identifier: "HeyMom", content: content, trigger: trigger)
         
         UNUserNotificationCenter.current().delegate = self
         
         UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
         
         //adding the notification to notification center
         UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
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


