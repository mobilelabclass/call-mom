//
//  FrequencySlider.swift
//  HeyMom
//
//  Created by Nien Lam on 5/9/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit

class FrequencySlider: UISlider {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let thumbImage = UIImage(named: "white-heart")
        self.setThumbImage(thumbImage, for: .normal)
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: bounds.width, height: 4)
    }

}
