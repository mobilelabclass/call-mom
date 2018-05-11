//
//  AppManager.swift
//  HeyMom
//
//  Created by Nien Lam on 4/17/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import Foundation
import Contacts
import UserNotifications

enum CallState {
    case Disconnected
    case Dialing
    case Incoming
    case Connected
}


// Mininum call time in seconds to be considered a "Call" to Mom.
private let minCallTime: Int = 5

// Initial reminder frequency.
private let initialDayCount: Int = 5

// These are paired arrays.
// Should make into struct but saving custom objects in user defaults is a pain.
private let callDateLogKey     = "CALL_DATE_LOG"
private let callDurationLogKey = "CALL_DURATION_LOG"

private let dayCountKey             = "DAY_COUNT"
private let momContactKey           = "MOM_CONTACT"
private let momPhoneNumberKey       = "MOM_PHONE_NUMBER_KEY"
private let isOnboardingCompleteKey = "IS_ONBOARDING_COMPLETE"


class AppManager: NSObject {
    // Declare this class as a singleton object.
    static let sharedInstance = AppManager()

    // Prevents others from using the default '()' initializer for this class.
    private override init() {
        super.init()
    }
    
    // Standard user defaults.
    let defaults = UserDefaults.standard
    
    // Flag for onboarding status.
    var isOnboardingComplete = false {
        didSet { defaults.set(isOnboardingComplete, forKey: isOnboardingCompleteKey) }
    }
    
    var lastCallDuration: Int? {
        return callDurationLog.last
    }

    var sinceLastCall: (seconds: Int, minutes: Int, hours: Int, days: Int)? {
        guard let lastCallDate = callDateLog.last else { return nil }
        
        let sinceLastCall = Date().timeIntervalSince(lastCallDate)
        
        return  (Int(sinceLastCall), Int(sinceLastCall / 60), Int(sinceLastCall / 3600), Int(sinceLastCall / 86400))
    }
    
    // Reminder frequency in days.
    var dayCount: Int = initialDayCount {
        didSet {
            defaults.set(dayCount, forKey: dayCountKey)
        }
    }
    
    var goalPercentage: Float {

        // TODO: Make this to days.
        if let sinceLastCall = self.sinceLastCall {
            let sinceDiff = max(dayCount - sinceLastCall.minutes, 0)

            return Float(sinceDiff) / Float(dayCount)
        }

        return 0
    }
    
    var momContact: CNContact? {
        didSet {
            if let object = momContact {
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: object)
                defaults.set(encodedData, forKey: momContactKey)
            }
        }
    }
    
    var momPhoneNumber: CNLabeledValue<CNPhoneNumber>? {
        didSet {
            if let object = momPhoneNumber {
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: object)
                defaults.set(encodedData, forKey: momPhoneNumberKey)
            }
        }
    }

    var momPhoneNumberURL: URL? {
        let n = momPhoneNumber?.value.stringValue
        
        guard let numberStripped = n?.replacingOccurrences(of: "\\D", with: "", options: .regularExpression) else {
            print("ERROR: Stored number invalid.")
            return nil
        }
        
        guard let numberURL = URL(string: "tel://" + numberStripped) else {
            print("ERROR: Stored number URL.")
            return nil
        }
        
        return numberURL
    }
    
    private(set) var callDateLog = [Date]()
    private(set) var callDurationLog = [Int]()

    
    // Callback method for call state changed.
    var callStateChanged: ((CallState) -> ())?

    var currentCallState: CallState = .Disconnected {
        didSet {
            self.callStateChanged?(currentCallState)
        }
    }


    // Check if mininum call time.
    func isMinimumCallTime(_ seconds: Int) -> Bool {
        return (seconds > minCallTime) ? true : false
    }
    
    // Save call date and duration.
    func saveCallLog(date: Date, duration: Int ) {
        callDateLog.append(date)
        callDurationLog.append(duration)
        
        defaults.set(callDateLog, forKey: callDateLogKey)
        defaults.set(callDurationLog, forKey: callDurationLogKey)
    }

    // Loads data from user defaults.
    func loadDefaults() {
        isOnboardingComplete = defaults.bool(forKey: isOnboardingCompleteKey)

        // Load settings once onboarding is complete.
        if isOnboardingComplete {
            callDateLog = defaults.object(forKey: callDateLogKey) as? [Date] ?? [Date]()
            
            callDurationLog = defaults.object(forKey: callDurationLogKey) as? [Int] ?? [Int]()
            
            dayCount = defaults.integer(forKey: dayCountKey)
            
            if let momContactData = defaults.object(forKey: momContactKey) as? Data {
                momContact = NSKeyedUnarchiver.unarchiveObject(with: momContactData) as? CNContact
            }
            
            if let momPhoneNumberData = defaults.object(forKey: momPhoneNumberKey) as? Data {
                momPhoneNumber = NSKeyedUnarchiver.unarchiveObject(with: momPhoneNumberData) as? CNLabeledValue<CNPhoneNumber>
            }
        }
    }

}


// Methods for local notifications.
extension AppManager: UNUserNotificationCenterDelegate {
    
    func setupLocalNotification() {
        // Request authorization for local notification.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound],
                                                                completionHandler: { didAllow, error in
        })

        UNUserNotificationCenter.current().delegate = self

        resetReminder()
    }
    
    func resetReminder() {
        let alertSeconds = Double(dayCount * 60)

        addNotification(timeInterval: alertSeconds, repeats: true)
    }
    
    func addNotification(timeInterval: TimeInterval, repeats: Bool) {
        // Creating the notification content.
        let content = UNMutableNotificationContent()
        
        // Adding title, subtitle, body and badge.
        content.title = "Reminder"
        content.body = "Call your Mom today!"
        content.sound = UNNotificationSound.default()
        //  content.subtitle = ""
        //  content.badge = 0
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
        
        //getting the notification request
        let request = UNNotificationRequest(identifier: "HeyMom", content: content, trigger: trigger)
        
        // Clear out any existing notification.
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Adding the notification to notification center.
        UNUserNotificationCenter.current().add(request) { (error) in
            print("Notification added with interval: \(timeInterval)")
        }
    }

    // UNUserNotificationCenterDelegate method.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Displaying the ios local notification when app is in foreground.
        completionHandler([.alert, .sound])
    }
}

