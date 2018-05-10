//
//  NumberUpdateViewController.swift
//  HeyMom
//
//  Created by Nien Lam on 5/7/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit
import ContactsUI

private let reuseIdentifier = "NumberTableViewCell"

class NumberUpdateViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    @IBOutlet weak var numberTextField: UITextField!

    @IBOutlet weak var tableView: UITableView!
    
    var tableData = [String]()

    var didGoBack: (() -> ())?
    var didGoNext: (() -> ())?
    
    // Set to true if using VC from settings view.
    var isSettingsMode = false;

    // Get global singleton object.
    let appMgr = AppManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Buttons user only for onboarding flow.
        if isSettingsMode {
            backButton.isHidden = true
            nextButton.isHidden = true
        }

        let color = UIColor.black.withAlphaComponent(0.45)
        numberTextField.attributedPlaceholder =
            NSAttributedString(string: "Mom's Number",
                               attributes: [NSAttributedStringKey.foregroundColor: color])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func handleBackButton(_ sender: UIButton) {
        self.didGoBack?()
    }
    
    @IBAction func handleNextButton(_ sender: UIButton) {
        self.didGoNext?()
    }

    @IBAction func handleContactsButton(_ sender: UIButton) {
        let picker = CNContactPickerViewController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
}


extension NumberUpdateViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {

        // Check if valid contact,
        //

        appMgr.momContact = contact

        
        self.tableData.removeAll()

        let givenName = contact.givenName
        let familyName = contact.familyName
        for phoneNumber in contact.phoneNumbers {

            appMgr.momPhoneNumber = phoneNumber


            let number = phoneNumber.value as CNPhoneNumber
            let label = phoneNumber.label
            let localizedLabel = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label!)
            print("\(givenName) - \(familyName) - \(localizedLabel) - \(number.stringValue)")

            self.tableData.append(number.stringValue)
            self.tableView.reloadData()
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
    }
}


extension NumberUpdateViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NumberTableViewCell
        
        let string = tableData[indexPath.row]
        
        cell.numberLabel.text = string
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let string = tableData[indexPath.row]
        
        numberTextField.text = string
    }
}

