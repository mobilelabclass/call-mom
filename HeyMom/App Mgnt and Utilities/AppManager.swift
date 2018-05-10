//
//  AppManager.swift
//  HeyMom
//
//  Created by Nien Lam on 4/17/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import Foundation
import Contacts

enum CallState {
    case Disconnected
    case Dialing
    case Incoming
    case Connected
}


// These are paired arrays.
// Should make into struct but saving custom objects in user defaults is a pain.
private let callDateLogKey     = "CALL_DATE_LOG"
private let callDurationLogKey = "CALL_DURATION_LOG"

private let dayCountKey        = "DAY_COUNT"
private let momContactKey      = "MOM_CONTACT"
private let momPhoneNumberKey  = "MOM_PHONE_NUMBER_KEY"

private let isOnboardingCompleteKey = "IS_ONBOARDING_COMPLETE"


class AppManager {
    // Declare this class as a singleton object.
    static let sharedInstance = AppManager()

    // Prevents others from using the default '()' initializer for this class.
    private init() {}

    // Standard user defaults.
    let defaults = UserDefaults.standard

    // Flag for onboarding status.
    var isOnboardingComplete = false {
        didSet {
            defaults.set(isOnboardingComplete, forKey: isOnboardingCompleteKey)
        }
    }
    
    var lastCallDuration: Int? {
        get { return callDurationLog.last }
    }

    var lastCallDate: Date? {
        get { return callDateLog.last }
    }

    // Reminder frequency in days.
    var dayCount: Int = 5 {
        didSet {
            defaults.set(dayCount, forKey: dayCountKey)
        }
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

    private(set) var callDateLog = [Date]()
    private(set) var callDurationLog = [Int]()

    // Number for making call.
    private(set) var telephoneNumber: URL?

    
    // Callback method for call state changed.
    var callStateChanged: ((CallState) -> ())?

    var currentCallState: CallState = .Disconnected {
        didSet {
            self.callStateChanged?(currentCallState)
        }
    }
    
    
    func loadDefaults() {

        isOnboardingComplete = defaults.bool(forKey: isOnboardingCompleteKey)

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
    
    func saveCallLog(date: Date, duration: Int ) {
        callDateLog.append(date)
        callDurationLog.append(duration)
        
        defaults.set(callDateLog, forKey: callDateLogKey)
        defaults.set(callDurationLog, forKey: callDurationLogKey)
    }
    
    func storeTelephoneNumber(_ number: String) {
        
        let numberString = number.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        
        guard let number = URL(string: "tel://" + numberString) else {
            print("ERROR: Number not valid")
            return
        }

        self.telephoneNumber = number
    }

}

