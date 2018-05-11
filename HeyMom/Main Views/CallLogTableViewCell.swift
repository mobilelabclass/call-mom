//
//  CallLogTableViewCell.swift
//  HeyMom
//
//  Created by Nien Lam on 5/10/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit

class CallLogTableViewCell: UITableViewCell {
    @IBOutlet weak var heartGraphic: UIImageView!
    
    @IBOutlet weak var callDateLabel: UILabel!
    @IBOutlet weak var callDurationLabel: UILabel!
    @IBOutlet weak var callTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = .clear
    }

}
