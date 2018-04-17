//
//  AppDelegate.swift
//  CallMom
//
//  Created by Nien Lam on 4/17/18.
//  Copyright © 2018 Mobile Lab. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var providerDelegate: ProviderDelegate!
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Create and setup provider delegate.
        providerDelegate = ProviderDelegate()
        providerDelegate.setupCallObserver()

        return true
    }
}

