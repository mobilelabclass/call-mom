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

class AppManager {
    // Declare this class as a singleton object.
    static let sharedInstance = AppManager()

    // Prevents others from using the default '()' initializer for this class.
    private init() {}

    // Number for making call.
    private(set) var telephoneNumber: URL?

    // Standard user defaults.
    let defaults = UserDefaults.standard
    
    
    // Reminder frequency in days.
    var dayCount: Int = 5
    

    var lastCallDuration: Int = 0 {
        didSet {
            
        }
    }

    var lastCallDate: Date? {
        didSet {
            
        }
    }

    var momContact: CNContact? {
        didSet {
            
        }
    }
    
    var momPhoneNumber: CNLabeledValue<CNPhoneNumber>? {
        didSet {
        }
    }
    
    // Callback method for call state changed.
    var callStateChanged: ((CallState) -> ())?

    var currentCallState: CallState = .Disconnected {
        didSet {
            self.callStateChanged?(currentCallState)
        }
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

