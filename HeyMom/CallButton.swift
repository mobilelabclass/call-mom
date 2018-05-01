//
//  CallButton.swift
//  HeyMom
//
//  Created by Nien Lam on 4/17/18.
//  Copyright © 2018 Mobile Lab. All rights reserved.
//

import UIKit

class CallButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // Make button into a circle.
        layer.cornerRadius = self.bounds.width / 2.0
        clipsToBounds = true
    }
    
}
