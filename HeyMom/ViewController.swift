//
//  ViewController.swift
//  HeyMom
//
//  Created by Nien Lam on 4/17/18.
//  Copyright © 2018 Mobile Lab. All rights reserved.
//

import UIKit
import Lottie
import DLLocalNotifications
import UserNotifications


class ViewController: UIViewController, UIGestureRecognizerDelegate, UNUserNotificationCenterDelegate {

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
        
        //requesting for authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            
        })
    }

    @objc
    func handleTap(sender: UITapGestureRecognizer) {
        animationView.play{ (finished) in
        }
    }
    
    
    // Make call with button press
    @IBAction func handleCallButton(_ sender: UIButton) {

        /*
        //creating the notification content
        let content = UNMutableNotificationContent()
        
        //adding title, subtitle, body and badge
        content.title = "Hey this is Simplified iOS"
        content.subtitle = "iOS Development is fun"
        content.body = "We are learning about iOS Local Notification"
        content.badge = 1
        
        //getting the notification trigger
        //it will be called after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        //getting the notification request
        let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        
        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        */
        
    }
    
    func timeStamp() -> String {
        return DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //displaying the ios local notification when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }


}


