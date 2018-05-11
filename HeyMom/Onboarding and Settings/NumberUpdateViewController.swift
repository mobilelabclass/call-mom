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

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    @IBOutlet weak var tableView: UITableView!
    
    var tableData = [CNLabeledValue<CNPhoneNumber>?]()

    var selectedRow: Int?
    
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
            titleLabel.text = "Select Mom from your Contacts"
        } else {
            titleLabel.text = "To get started, select Mom from your Contacts"
            nextButton.isEnabled = false
        }

        // Show stored phone number
        if let phoneNumer = appMgr.momPhoneNumber {
            tableData.append(phoneNumer)
            selectedRow = 0
        }
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
        tableData.removeAll()
        selectedRow = nil
        
        for phoneNumber in contact.phoneNumbers {
            tableData.append(phoneNumber)
            selectedRow = 0
        }

        if tableData.count == 0 {
            titleLabel.text = "Sorry, no number found"
            nextButton.isEnabled = false
        } else {
            titleLabel.text = "Select Mom from your Contacts"

            appMgr.momPhoneNumber = tableData[0]

            nextButton.isEnabled = true
        }
        
        tableView.reloadData()
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
        
        let phoneNumber = tableData[indexPath.row]!

        let localizedLabel = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: phoneNumber.label!)
        let number         = phoneNumber.value as CNPhoneNumber
        
        cell.categoryLabel.text  = localizedLabel
        
        if selectedRow == indexPath.row {
            cell.numberLabel.text    =  "• \(number.stringValue) •"
            cell.categoryLabel.textColor = .black
            cell.numberLabel.textColor = .black
        } else {
            cell.numberLabel.text    =  number.stringValue
            cell.categoryLabel.textColor = UIColor.white.withAlphaComponent(0.6)
            cell.numberLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        
        appMgr.momPhoneNumber = tableData[indexPath.row]
        
        tableView.reloadData()
    }
}

