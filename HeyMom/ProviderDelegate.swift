//
//  ProviderDelegate.swift
//  HeyMom
//
//  Created by Nien Lam on 4/17/18.
//  Copyright © 2018 Mobile Lab. All rights reserved.
//

import CallKit

// System method for observing call states.
class ProviderDelegate: NSObject, CXCallObserverDelegate {
    var callObserver: CXCallObserver!
    
    func setupCallObserver(){
        callObserver = CXCallObserver()
        callObserver.setDelegate(self, queue: nil)
    }

    // Observer states and set app manager value.
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {

        let appMgr = AppManager.sharedInstance

        if call.hasEnded == true {
            appMgr.currentCallState = .Disconnected

        } else if call.isOutgoing == true && call.hasConnected == false {
            appMgr.currentCallState = .Dialing

        } else if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
            appMgr.currentCallState = .Incoming

        } else if call.hasConnected == true && call.hasEnded == false {
            appMgr.currentCallState = .Connected

        }
    }
}
