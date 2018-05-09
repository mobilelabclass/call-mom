//
//  AppDelegate.swift
//  HeyMom
//
//  Created by Nien Lam on 4/17/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var providerDelegate: ProviderDelegate!
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Make status bar white.
        UIApplication.shared.statusBarStyle = .lightContent

        // Clear badges number.
        UIApplication.shared.applicationIconBadgeNumber = 0;
        
        // Create and setup provider delegate.
        providerDelegate = ProviderDelegate()
        providerDelegate.setupCallObserver()
        
        return true
    }
}

