//
//  CreditsViewController.swift
//  HeyMom
//
//  Created by Nien Lam on 5/9/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func handleCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleLBLink(_ sender: UIButton) {
        let url = URL(string: "http://www.linebreak.studio")!
        let alert = UIAlertController(title: "Open Safari?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (action) -> Void in
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
}
